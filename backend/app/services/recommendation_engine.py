from typing import Any

from app.models.recommendation import (
    PackagingAlternative,
    PackagingRecommendation,
)
from app.models.schemas import PackagingRequest


def _clamp(value: float, minimum: float = 0.0, maximum: float = 100.0) -> float:
    return max(minimum, min(value, maximum))


def _barrier_score(
    candidate: dict[str, Any],
    moisture: float,
    fat: float,
    oxygen_sensitivity: str,
    moisture_sensitivity: str,
) -> float:
    score = 50.0

    barrier = candidate["barrier_level"].lower()

    # Oxygen-sensitive foods benefit from stronger oxygen barriers.
    if oxygen_sensitivity.lower() == "high":
        if "high" in barrier:
            score += 25
        elif "medium" in barrier:
            score += 10
        else:
            score -= 15

    # Moisture-sensitive foods benefit from stronger moisture barriers.
    if moisture_sensitivity.lower() == "high":
        if "high" in barrier:
            score += 20
        elif "medium" in barrier:
            score += 8
        else:
            score -= 10

    # High-fat foods need good barrier protection.
    if fat >= 10:
        if "high" in barrier:
            score += 10
        elif "medium" in barrier:
            score += 5
        else:
            score -= 5

    # Very moist foods need protection against moisture loss.
    if moisture >= 80:
        if "high" in barrier:
            score += 8
        elif "medium" in barrier:
            score += 4

    return _clamp(score)


def _mechanical_score(
    candidate: dict[str, Any],
    transport_mode: str,
    transport_duration: int,
) -> float:
    strength = candidate["mechanical_strength"].lower()

    score = 60.0

    if "high" in strength:
        score += 25
    elif "medium" in strength:
        score += 10
    else:
        score -= 10

    # Longer transport requires stronger packaging.
    if transport_duration >= 48:
        if "high" in strength:
            score += 10
        else:
            score -= 10

    # Road transport can involve vibration and handling.
    if transport_mode.lower() in {"truck", "road", "lorry"}:
        if "high" in strength:
            score += 5

    return _clamp(score)


def _sustainability_score(candidate: dict[str, Any]) -> float:
    return float(candidate["sustainability_score"])


def _cost_score(candidate: dict[str, Any]) -> float:
    return float(candidate["cost_score"])


def _calculate_score(
    candidate: dict[str, Any],
    request: PackagingRequest,
    food_profile: dict[str, Any],
) -> float:
    barrier = _barrier_score(
        candidate=candidate,
        moisture=request.moisture,
        fat=request.fat,
        oxygen_sensitivity=food_profile["oxygen_sensitivity"],
        moisture_sensitivity=food_profile["moisture_sensitivity"],
    )

    mechanical = _mechanical_score(
        candidate=candidate,
        transport_mode=request.transport_mode,
        transport_duration=request.transport_duration,
    )

    sustainability = _sustainability_score(candidate)
    cost = _cost_score(candidate)

    # Explainable prototype weighting.
    final_score = (
        barrier * 0.45
        + mechanical * 0.20
        + sustainability * 0.20
        + cost * 0.15
    )

    # Longer shelf life increases the importance of barrier performance.
    if request.shelf_life >= 30:
        final_score += barrier * 0.05

    return round(_clamp(final_score), 2)


def _map_suitability(candidate: dict[str, Any], food_profile: dict[str, Any]) -> str:
    gas_requirement = food_profile["gas_exchange_requirement"].lower()
    gas_permeability = candidate["gas_permeability"].lower()

    if "high" in gas_requirement and "high" in gas_permeability:
        return "High"

    if "moderate" in gas_requirement and (
        "high" in gas_permeability or "medium" in gas_permeability
    ):
        return "Suitable"

    if "low" in gas_requirement and "low" in gas_permeability:
        return "High"

    return "Moderate"


def _reasoning(
    candidate: dict[str, Any],
    request: PackagingRequest,
    food_profile: dict[str, Any],
) -> list[str]:
    reasons: list[str] = []

    if food_profile["oxygen_sensitivity"].lower() == "high":
        reasons.append(
            "The food profile indicates high oxygen sensitivity, "
            "so barrier protection is prioritized."
        )

    if food_profile["moisture_sensitivity"].lower() == "high":
        reasons.append(
            "Moisture control is important for maintaining product quality "
            "and reducing moisture-related deterioration."
        )

    if request.fat >= 10:
        reasons.append(
            "The supplied fat/oil value increases the importance of "
            "strong barrier protection."
        )

    if request.shelf_life >= 30:
        reasons.append(
            "The requested longer shelf life increases the weighting "
            "given to barrier performance."
        )

    if request.transport_duration >= 48:
        reasons.append(
            "The transport duration increases the importance of "
            "mechanical protection."
        )

    reasons.append(candidate["reason"])

    return reasons


def recommend_packaging(
    request: PackagingRequest,
    food_profile: dict[str, Any],
    candidates: list[dict[str, Any]],
) -> PackagingRecommendation:
    if not candidates:
        raise ValueError("No packaging candidates available for this commodity.")

    ranked: list[tuple[dict[str, Any], float]] = []

    for candidate in candidates:
        score = _calculate_score(
            candidate=candidate,
            request=request,
            food_profile=food_profile,
        )
        ranked.append((candidate, score))

    ranked.sort(key=lambda item: item[1], reverse=True)

    best, best_score = ranked[0]

    alternatives = [
        PackagingAlternative(
            material=candidate["material"],
            structure=candidate["structure"],
            packaging_type=candidate["packaging_type"],
            score=score,
            reason=candidate["reason"],
        )
        for candidate, score in ranked[1:4]
    ]

    thickness = (
        f'{best["thickness_min"]:.1f}–{best["thickness_max"]:.1f} mm'
    )

    barrier = best["barrier_level"]

    if barrier.lower() == "high":
        otr = "Low OTR"
        wvtr = "Low WVTR"
    elif barrier.lower() == "medium":
        otr = "Medium OTR"
        wvtr = "Medium WVTR"
    else:
        otr = "Higher OTR"
        wvtr = "Higher WVTR"

    return PackagingRecommendation(
        commodity=request.commodity,
        recommended_material=best["material"],
        structure=best["structure"],
        packaging_type=best["packaging_type"],
        compatibility_score=best_score,
        thickness=thickness,
        barrier_level=best["barrier_level"],
        otr=otr,
        wvtr=wvtr,
        sealability=best["sealability"],
        mechanical_strength=best["mechanical_strength"],
        gas_permeability=best["gas_permeability"],
        map_suitability=_map_suitability(
            candidate=best,
            food_profile=food_profile,
        ),
        sustainability_score=float(best["sustainability_score"]),
        cost_score=float(best["cost_score"]),
        reasoning=_reasoning(
            candidate=best,
            request=request,
            food_profile=food_profile,
        ),
        alternatives=alternatives,
        disclaimer=(
            "This is an AI-assisted prototype recommendation. "
            "Packaging selection should be validated using product-specific "
            "testing, packaging-grade specifications, and applicable standards "
            "before commercial use."
        ),
    )