"""
ECO WRAP - Packaging Recommendation Engine

Explainable packaging compatibility and ranking engine.

The engine combines:
    - Food/barrier compatibility
    - Team dataset respiration information when available
    - Quantitative respiration estimation as fallback
    - Relative humidity
    - Mechanical requirements
    - Sustainability
    - Cost

Respiration priority:
    1. Team dataset value, when available
    2. Quantitative ECO WRAP respiration reference database, when available
"""

from app.services.respiration_service import estimate_respiration_rate


def _clamp(
    value: float,
    minimum: float = 0.0,
    maximum: float = 100.0,
) -> float:
    """Keep a score between minimum and maximum."""
    return max(minimum, min(maximum, value))


def _barrier_score(candidate, food_profile, request) -> float:
    """Score oxygen/moisture/fat barrier compatibility."""

    score = 50.0

    if food_profile["oxygen_sensitivity"] == "High":
        if candidate["barrier_level"] == "High":
            score += 30
        elif candidate["barrier_level"] == "Medium":
            score += 10
        else:
            score -= 20

    elif food_profile["oxygen_sensitivity"] == "Medium":
        if candidate["barrier_level"] == "High":
            score += 20
        elif candidate["barrier_level"] == "Medium":
            score += 15

    if food_profile["moisture_sensitivity"] == "High":
        if candidate["barrier_level"] == "High":
            score += 15
        elif candidate["barrier_level"] == "Medium":
            score += 5
        else:
            score -= 15

    if request.fat > 10:
        if candidate["barrier_level"] == "High":
            score += 10
        elif candidate["barrier_level"] == "Low":
            score -= 10

    if request.moisture > 70:
        if candidate["barrier_level"] == "High":
            score += 5

    return _clamp(score)


def _respiration_score(candidate, respiration_class: str) -> float:
    """
    Score packaging according to respiration class.

    For N/A or unknown respiration values, return a neutral score.
    """

    permeability = candidate["gas_permeability"]

    if respiration_class == "Very High":
        if permeability == "High":
            return 100.0
        if permeability == "Medium":
            return 75.0
        return 40.0

    if respiration_class == "High":
        if permeability == "High":
            return 95.0
        if permeability == "Medium":
            return 75.0
        return 45.0

    if respiration_class == "Medium":
        if permeability == "High":
            return 85.0
        if permeability == "Medium":
            return 95.0
        return 65.0

    if respiration_class == "Low":
        if permeability == "Low":
            return 95.0
        if permeability == "Medium":
            return 80.0
        return 60.0

    # N/A / unknown respiration:
    # Do not invent a respiration class.
    return 50.0


def _humidity_score(
    candidate,
    humidity: float,
    moisture_sensitivity: str,
) -> float:
    """Score packaging against storage relative humidity."""

    score = 60.0

    if humidity >= 80:
        if candidate["barrier_level"] == "High":
            score += 30
        elif candidate["barrier_level"] == "Medium":
            score += 15
        else:
            score -= 10

    elif humidity >= 60:
        if candidate["barrier_level"] == "High":
            score += 20
        elif candidate["barrier_level"] == "Medium":
            score += 10

    else:
        if candidate["barrier_level"] in ("High", "Medium"):
            score += 10

    if moisture_sensitivity == "High" and humidity >= 70:
        if candidate["barrier_level"] == "High":
            score += 10

    return _clamp(score)


def _mechanical_score(
    candidate,
    transport_mode: str,
    transport_duration: int,
) -> float:
    """Score mechanical protection based on transport conditions."""

    score = 60.0

    strength = candidate["mechanical_strength"]

    if transport_mode.lower() in (
        "truck",
        "road",
        "rail",
        "ship",
        "refrigerated truck",
    ):
        if strength == "High":
            score += 30
        elif strength == "Medium":
            score += 15
        else:
            score -= 10

    if transport_duration >= 48:
        if strength == "High":
            score += 10
        elif strength == "Low":
            score -= 10

    return _clamp(score)


def _sustainability_score(candidate) -> float:
    """Return the candidate sustainability score."""
    return float(candidate["sustainability_score"])


def _cost_score(candidate) -> float:
    """Return the candidate cost score."""
    return float(candidate["cost_score"])


def _calculate_score(
    candidate,
    barrier_score: float,
    respiration_score: float,
    humidity_score: float,
    mechanical_score: float,
    shelf_life: int,
) -> float:
    """
    Calculate the overall compatibility score.

    Weights:
        Barrier compatibility = 35%
        Respiration           = 20%
        Humidity              = 10%
        Mechanical strength  = 15%
        Sustainability       = 10%
        Cost                  = 10%

    For long desired shelf life, barrier compatibility receives
    a small additional influence.
    """

    score = (
        barrier_score * 0.35
        + respiration_score * 0.20
        + humidity_score * 0.10
        + mechanical_score * 0.15
        + _sustainability_score(candidate) * 0.10
        + _cost_score(candidate) * 0.10
    )

    if shelf_life >= 30:
        score += barrier_score * 0.05

    return _clamp(score)


def _map_suitability(
    candidate,
    food_profile,
    respiration_class: str,
) -> str:
    """Determine whether the packaging is suitable for MAP."""

    gas_requirement = food_profile["gas_exchange_requirement"]

    if gas_requirement == "High":
        if candidate["gas_permeability"] == "High":
            return "High"

        if candidate["gas_permeability"] == "Medium":
            return "Moderate"

        return "Low"

    if respiration_class in ("High", "Very High"):
        if candidate["gas_permeability"] == "High":
            return "Moderate"

        return "Low"

    if candidate["barrier_level"] == "High":
        return "High"

    return "Moderate"


def _reasoning(
    candidate,
    food_profile,
    request,
    respiration_rate,
    respiration_class: str,
    respiration_source: str,
) -> list[str]:
    """Generate human-readable explanation for the recommendation."""

    reasons = []

    if respiration_rate is not None:
        reasons.append(
            f"Estimated respiration rate is "
            f"{respiration_rate:.2f} mL CO2/kg/h at "
            f"{request.temperature:.1f}°C ({respiration_class})."
        )
    elif respiration_class:
        reasons.append(
            f"Team dataset respiration classification: "
            f"{respiration_class}."
        )

    if respiration_class in ("High", "Very High"):
        if candidate["gas_permeability"] == "High":
            reasons.append(
                "High gas permeability supports the higher respiration "
                "and gas-exchange requirement."
            )
        else:
            reasons.append(
                "The selected structure provides controlled gas exchange "
                "for the commodity."
            )

    elif respiration_class == "Low":
        if candidate["barrier_level"] == "High":
            reasons.append(
                "Higher barrier performance is appropriate for the "
                "lower respiration condition."
            )

    elif respiration_class.startswith("N/A"):
        reasons.append(
            "Respiration is marked N/A in the team dataset; "
            "no respiration value was invented for this commodity."
        )

    if request.humidity >= 80:
        if candidate["barrier_level"] == "High":
            reasons.append(
                "High barrier performance helps protect against the "
                "high relative-humidity storage condition."
            )

    if request.transport_duration >= 48:
        if candidate["mechanical_strength"] == "High":
            reasons.append(
                "High mechanical strength supports longer transport."
            )

    if candidate["sustainability_score"] >= 80:
        reasons.append(
            "This option has a strong sustainability score within "
            "the ECO WRAP prototype database."
        )

    if request.shelf_life >= 30:
        if candidate["barrier_level"] == "High":
            reasons.append(
                "The higher barrier level supports the requested "
                "longer storage period."
            )

    if respiration_source == "team_dataset":
        reasons.append(
            "Team dataset values are prioritized for supported "
            "common commodities."
        )

    return reasons


def recommend_packaging(
    request,
    food_profile,
    candidates,
    team_data=None,
):
    """
    Generate the final packaging recommendation.

    Respiration priority:

    1. Team dataset
    2. Quantitative ECO WRAP respiration reference database

    If the team dataset contains N/A for respiration, the value
    remains N/A and is not converted into a fabricated respiration
    class.
    """

    # ---------------------------------------------------------------
    # 1. Determine respiration information
    # ---------------------------------------------------------------

    team_respiration = None

    if team_data:
        raw_team_respiration = team_data.get("respiration_rate")

        if raw_team_respiration:
            team_respiration = str(raw_team_respiration).strip()

    # ---------------------------------------------------------------
    # 1A. Team dataset has the respiration value
    # ---------------------------------------------------------------

    if team_respiration:

        respiration_class = team_respiration
        respiration_source = "team_dataset"

        # N/A is intentionally preserved.
        if respiration_class.upper().startswith("N/A"):
            respiration_rate = None

            respiration = {
                "available": False,
                "estimated_rate": None,
                "unit": None,
                "temperature_c": request.temperature,
                "method": "Not applicable",
                "reference_source": "Team dataset",
            }

        else:
            # Team qualitative value is used for scoring.
            # We still calculate a quantitative reference value
            # when available as supporting information only.
            quantitative_respiration = estimate_respiration_rate(
                commodity=request.commodity,
                temperature_c=request.temperature,
            )

            if quantitative_respiration["available"]:
                respiration_rate = quantitative_respiration[
                    "estimated_rate"
                ]

                respiration = quantitative_respiration

            else:
                respiration_rate = None

                respiration = {
                    "available": False,
                    "estimated_rate": None,
                    "unit": None,
                    "temperature_c": request.temperature,
                    "method": "Team dataset qualitative value",
                    "reference_source": "Team dataset",
                }

    # ---------------------------------------------------------------
    # 1B. No team respiration value → quantitative fallback
    # ---------------------------------------------------------------

    else:

        respiration = estimate_respiration_rate(
            commodity=request.commodity,
            temperature_c=request.temperature,
        )

        if not respiration["available"]:
            raise ValueError(
                f"No respiration reference profile is available for "
                f"'{request.commodity}'."
            )

        respiration_rate = respiration["estimated_rate"]
        respiration_class = respiration["respiration_class"]
        respiration_source = "reference_database"

    # ---------------------------------------------------------------
    # 2. Score every packaging candidate
    # ---------------------------------------------------------------

    scored_candidates = []

    for candidate in candidates:

        barrier = _barrier_score(
            candidate=candidate,
            food_profile=food_profile,
            request=request,
        )

        respiration_score = _respiration_score(
            candidate=candidate,
            respiration_class=respiration_class,
        )

        humidity = _humidity_score(
            candidate=candidate,
            humidity=request.humidity,
            moisture_sensitivity=food_profile[
                "moisture_sensitivity"
            ],
        )

        mechanical = _mechanical_score(
            candidate=candidate,
            transport_mode=request.transport_mode,
            transport_duration=request.transport_duration,
        )

        total_score = _calculate_score(
            candidate=candidate,
            barrier_score=barrier,
            respiration_score=respiration_score,
            humidity_score=humidity,
            mechanical_score=mechanical,
            shelf_life=request.shelf_life,
        )

        scored_candidates.append(
            {
                "candidate": candidate,
                "score": total_score,
            }
        )

    # ---------------------------------------------------------------
    # 3. Rank candidates
    # ---------------------------------------------------------------

    scored_candidates.sort(
        key=lambda item: item["score"],
        reverse=True,
    )

    best = scored_candidates[0]
    best_candidate = best["candidate"]
    best_score = best["score"]

    # ---------------------------------------------------------------
    # 4. Generate alternatives
    # ---------------------------------------------------------------

    alternatives = []

    for item in scored_candidates[1:4]:

        candidate = item["candidate"]

        alternatives.append(
            {
                "material": candidate["material"],
                "structure": candidate["structure"],
                "packaging_type": candidate["packaging_type"],
                "score": round(item["score"], 1),
                "reason": candidate["reason"],
            }
        )

    # ---------------------------------------------------------------
    # 5. MAP suitability
    # ---------------------------------------------------------------

    map_suitability = _map_suitability(
        candidate=best_candidate,
        food_profile=food_profile,
        respiration_class=respiration_class,
    )

    # ---------------------------------------------------------------
    # 6. Human-readable reasoning
    # ---------------------------------------------------------------

    reasoning = _reasoning(
        candidate=best_candidate,
        food_profile=food_profile,
        request=request,
        respiration_rate=respiration_rate,
        respiration_class=respiration_class,
        respiration_source=respiration_source,
    )

    # ---------------------------------------------------------------
    # 7. Final response
    # ---------------------------------------------------------------

    return {
        "commodity": request.commodity,
        "recommended_material": best_candidate["material"],
        "structure": best_candidate["structure"],
        "packaging_type": best_candidate["packaging_type"],
        "compatibility_score": round(best_score, 1),
        "thickness": (
            f'{best_candidate["thickness_min"]:.2f}-'
            f'{best_candidate["thickness_max"]:.2f} mm'
        ),
        "barrier_level": best_candidate["barrier_level"],
        "otr": (
            "Low"
            if best_candidate["barrier_level"] == "High"
            else "Medium"
        ),
        "wvtr": (
            "Low"
            if best_candidate["barrier_level"] == "High"
            else "Medium"
        ),
        "sealability": best_candidate["sealability"],
        "mechanical_strength": best_candidate["mechanical_strength"],
        "gas_permeability": best_candidate["gas_permeability"],
        "map_suitability": map_suitability,
        "sustainability_score": float(
            best_candidate["sustainability_score"]
        ),
        "cost_score": float(
            best_candidate["cost_score"]
        ),
        "reasoning": reasoning,
        "alternatives": alternatives,

        # -----------------------------------------------------------
        # Respiration information
        # -----------------------------------------------------------

        "estimated_respiration_rate": respiration_rate,
        "respiration_unit": respiration["unit"],
        "respiration_class": respiration_class,
        "respiration_temperature": respiration["temperature_c"],
        "respiration_method": respiration["method"],
        "respiration_reference_source": respiration[
            "reference_source"
        ],
        "respiration_data_source": respiration_source,

        "disclaimer": (
            "Packaging recommendations are AI-assisted prototype "
            "recommendations based on team and reference data. "
            "Respiration values marked N/A are not converted into "
            "invented numerical values. Actual packaging performance "
            "depends on commodity variety, maturity, temperature, "
            "atmosphere, packaging grade, thickness, perforation "
            "and test conditions. Validate with laboratory and "
            "packaging trials before industrial use."
        ),
    }