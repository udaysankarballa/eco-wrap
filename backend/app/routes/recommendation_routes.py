from fastapi import APIRouter, HTTPException

from app.models.schemas import PackagingRequest
from app.services.recommendation_engine import recommend_packaging
from app.services.team_dataset_service import get_team_commodity_data


router = APIRouter(
    prefix="/api",
    tags=["Packaging Recommendation"],
)


# ---------------------------------------------------------------------------
# ECO WRAP COMMODITY PROFILES
# Prototype profiles for the commodities currently available in the Flutter app.
# These can later be replaced with the team's collected dataset.
# ---------------------------------------------------------------------------

FOOD_PROFILES = {
    # =========================
    # FRUITS
    # =========================
    "mango": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "apple": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "banana": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "grapes": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "orange": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "papaya": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "pineapple": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "watermelon": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "guava": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },

    # =========================
    # VEGETABLES
    # =========================
    "tomato": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "potato": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "onion": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "carrot": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "cabbage": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "broccoli": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "spinach": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "high",
    },
    "capsicum": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },
    "cucumber": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "moderate",
    },

    # =========================
    # GRAINS
    # =========================
    "rice": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "wheat": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "maize": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "oats": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "barley": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "millet": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "corn": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "quinoa": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "sorghum": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },

    # =========================
    # DAIRY
    # =========================
    "milk": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "moderate",
        "gas_exchange_requirement": "low",
    },
    "cheese": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "butter": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "moderate",
        "gas_exchange_requirement": "low",
    },
    "yogurt": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "cream": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "paneer": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },

    # =========================
    # MEAT / ANIMAL PRODUCTS
    # =========================
    "chicken": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "fish": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "mutton": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "beef": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "pork": {
        "oxygen_sensitivity": "high",
        "moisture_sensitivity": "high",
        "gas_exchange_requirement": "low",
    },
    "eggs": {
        "oxygen_sensitivity": "moderate",
        "moisture_sensitivity": "moderate",
        "gas_exchange_requirement": "low",
    },
}


# ---------------------------------------------------------------------------
# PACKAGING CANDIDATES
# ---------------------------------------------------------------------------

def fresh_produce_candidates():
    return [
        {
            "material": "Perforated PE Film",
            "structure": "PE film with controlled perforation",
            "packaging_type": "Fresh produce pouch",
            "barrier_level": "Medium",
            "sealability": "High",
            "mechanical_strength": "Medium",
            "gas_permeability": "High",
            "thickness_min": 0.03,
            "thickness_max": 0.08,
            "sustainability_score": 65,
            "cost_score": 90,
            "reason": "Supports controlled gas exchange while reducing excessive moisture loss.",
        },
        {
            "material": "Microperforated PP Film",
            "structure": "PP film with microperforation",
            "packaging_type": "Fresh produce pouch",
            "barrier_level": "Medium",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "High",
            "thickness_min": 0.03,
            "thickness_max": 0.07,
            "sustainability_score": 60,
            "cost_score": 85,
            "reason": "Balances respiration management with mechanical protection during transport.",
        },
        {
            "material": "Perforated PLA Film",
            "structure": "PLA film with controlled perforation",
            "packaging_type": "Compostable produce pouch",
            "barrier_level": "Medium",
            "sealability": "Medium",
            "mechanical_strength": "Medium",
            "gas_permeability": "High",
            "thickness_min": 0.04,
            "thickness_max": 0.09,
            "sustainability_score": 90,
            "cost_score": 55,
            "reason": "Provides a more sustainable alternative for fresh produce packaging.",
        },
    ]


def grain_candidates():
    return [
        {
            "material": "Woven PP with PE Liner",
            "structure": "Woven polypropylene with inner PE liner",
            "packaging_type": "Grain bag",
            "barrier_level": "High",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.10,
            "thickness_max": 0.20,
            "sustainability_score": 55,
            "cost_score": 85,
            "reason": "Provides strong moisture protection and mechanical strength for grain storage and transport.",
        },
        {
            "material": "PET/PE Laminate",
            "structure": "PET outer layer with PE sealing layer",
            "packaging_type": "Barrier pouch",
            "barrier_level": "High",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.08,
            "thickness_max": 0.15,
            "sustainability_score": 45,
            "cost_score": 70,
            "reason": "Provides strong barrier performance for moisture-sensitive grain products.",
        },
    ]


def dairy_candidates():
    return [
        {
            "material": "PET/PE Barrier Laminate",
            "structure": "PET outer layer with PE sealing layer",
            "packaging_type": "Barrier pouch",
            "barrier_level": "High",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.08,
            "thickness_max": 0.15,
            "sustainability_score": 50,
            "cost_score": 75,
            "reason": "Provides moisture and oxygen protection suitable for chilled dairy products.",
        },
        {
            "material": "PP Container",
            "structure": "Rigid polypropylene container",
            "packaging_type": "Rigid food container",
            "barrier_level": "Medium",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.30,
            "thickness_max": 0.80,
            "sustainability_score": 65,
            "cost_score": 80,
            "reason": "Provides good mechanical protection and practical sealing for dairy applications.",
        },
    ]


def meat_candidates():
    return [
        {
            "material": "PA/PE Vacuum Pouch",
            "structure": "Polyamide outer layer with PE sealing layer",
            "packaging_type": "Vacuum pouch",
            "barrier_level": "High",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.07,
            "thickness_max": 0.15,
            "sustainability_score": 45,
            "cost_score": 70,
            "reason": "High barrier and mechanical protection make it suitable for chilled meat and fish products.",
        },
        {
            "material": "PET/PE MAP Tray",
            "structure": "Rigid tray with high-barrier top film",
            "packaging_type": "MAP tray",
            "barrier_level": "High",
            "sealability": "High",
            "mechanical_strength": "High",
            "gas_permeability": "Low",
            "thickness_min": 0.30,
            "thickness_max": 0.60,
            "sustainability_score": 50,
            "cost_score": 65,
            "reason": "Provides structural protection and controlled atmosphere compatibility for fresh meat products.",
        },
    ]


PACKAGING_CANDIDATES = {}

# Fresh produce
for commodity in [
    "mango",
    "apple",
    "banana",
    "grapes",
    "orange",
    "papaya",
    "pineapple",
    "watermelon",
    "guava",
    "tomato",
    "potato",
    "onion",
    "carrot",
    "cabbage",
    "broccoli",
    "spinach",
    "capsicum",
    "cucumber",
]:
    PACKAGING_CANDIDATES[commodity] = fresh_produce_candidates()


# Grains
for commodity in [
    "rice",
    "wheat",
    "maize",
    "oats",
    "barley",
    "millet",
    "corn",
    "quinoa",
    "sorghum",
]:
    PACKAGING_CANDIDATES[commodity] = grain_candidates()


# Dairy
for commodity in [
    "milk",
    "cheese",
    "butter",
    "yogurt",
    "cream",
    "paneer",
]:
    PACKAGING_CANDIDATES[commodity] = dairy_candidates()


# Meat / animal products
for commodity in [
    "chicken",
    "fish",
    "mutton",
    "beef",
    "pork",
    "eggs",
]:
    PACKAGING_CANDIDATES[commodity] = meat_candidates()


# ---------------------------------------------------------------------------
# API ENDPOINT
# ---------------------------------------------------------------------------

@router.post("/recommend", response_model=object)
def get_packaging_recommendation(request: PackagingRequest):
    commodity_key = request.commodity.strip().lower()
    team_data = get_team_commodity_data(request.commodity)

    if team_data:
        print(
            f"ECO WRAP: Using team dataset for "
            f"{team_data['commodity']} | "
            f"Respiration: {team_data['respiration_rate']}"
        )

    if commodity_key not in FOOD_PROFILES:
        raise HTTPException(
            status_code=404,
            detail=(
                f"No ECO WRAP profile is currently available "
                f"for '{request.commodity}'."
            ),
        )

    food_profile = FOOD_PROFILES[commodity_key]

    candidates = PACKAGING_CANDIDATES.get(commodity_key, [])

    if not candidates:
        raise HTTPException(
            status_code=404,
            detail=f"No packaging candidates available for '{request.commodity}'.",
        )

    try:
        return recommend_packaging(
            request=request,
            food_profile=food_profile,
            candidates=candidates,
            team_data=team_data,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=400,
            detail=str(exc),
        ) from exc

