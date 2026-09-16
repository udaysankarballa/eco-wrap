"""
ECO WRAP - Team Dataset Service

Reads the food commodity dataset collected by the team.

For the current version, this service is used only for commodities
that are present in both the ECO WRAP app and the team dataset.

The dataset remains the source of truth for these commodities.
"""

import csv
from pathlib import Path


DATASET_PATH = (
    Path(__file__).resolve().parent.parent / "data" / "team_food_data.csv"
)


def _clean_value(value):
    """Convert empty CSV cells to None and trim text values."""

    if value is None:
        return None

    value = str(value).strip()

    if not value:
        return None

    return value


def _normalize_name(name: str) -> str:
    """Normalize commodity names for matching."""

    return " ".join(name.strip().lower().split())


def get_team_commodity_data(commodity: str):
    """
    Find a commodity in the team dataset.

    Returns the first matching dataset row.

    Returns:
        dict | None
    """

    requested_name = _normalize_name(commodity)

    if not DATASET_PATH.exists():
        raise FileNotFoundError(
            f"Team dataset not found: {DATASET_PATH}"
        )

    with DATASET_PATH.open(
        mode="r",
        encoding="utf-8-sig",
        newline="",
    ) as file:

        reader = csv.DictReader(file)

        for row in reader:
            dataset_name = _clean_value(row.get("Commodity"))

            if dataset_name is None:
                continue

            if _normalize_name(dataset_name) == requested_name:
                return {
                    "commodity": dataset_name,
                    "category": _clean_value(row.get("Category")),
                    "ph": _clean_value(row.get("pH")),
                    "moisture": _clean_value(
                        row.get("Moisture_Content")
                    ),
                    "storage_temperature": _clean_value(
                        row.get("Storage_Temperature")
                    ),
                    "respiration_rate": _clean_value(
                        row.get("Respiration_Rate")
                    ),
                    "oxygen_sensitivity": _clean_value(
                        row.get("Oxygen_Sensitivity")
                    ),
                    "moisture_sensitivity": _clean_value(
                        row.get("Moisture_Sensitivity")
                    ),
                    "light_sensitivity": _clean_value(
                        row.get("Light_Sensitivity")
                    ),
                    "shelf_life": _clean_value(
                        row.get("Typical_Shelf_Life")
                    ),
                    "recommended_packaging": _clean_value(
                        row.get("Recommended_Packaging")
                    ),
                    "packaging_reason": _clean_value(
                        row.get("Packaging_Reason")
                    ),
                    "farmer_action": _clean_value(
                        row.get("Farmer_Action")
                    ),
                    "source": "team_dataset",
                }

    return None


def get_team_respiration_rate(commodity: str):
    """
    Return the team's respiration value for a commodity.

    The value is returned exactly as stored in the dataset.

    Examples:
        High
        Medium
        Low
        Medium-High
        N/A
        None
    """

    data = get_team_commodity_data(commodity)

    if data is None:
        return None

    return data["respiration_rate"]


def is_commodity_in_team_dataset(commodity: str) -> bool:
    """Check whether a commodity exists in the team dataset."""

    return get_team_commodity_data(commodity) is not None