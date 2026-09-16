"""
ECO WRAP - Respiration Reference Database

Reference respiration data for prototype estimation.

Units:
    mL CO2 / kg / h

Important:
    These are reference values, not laboratory measurements.
    Actual respiration varies with cultivar, maturity, temperature,
    storage atmosphere, handling and other conditions.
"""


RESPIRATION_DATABASE = {
    # ------------------------------------------------------------------
    # FRUITS / VEGETABLES
    # ------------------------------------------------------------------

    "tomato": {
        "unit": "mL CO2/kg/h",
        "reference_source": "Published tomato respiration studies",
        "temperatures_c": [10.0, 20.0, 28.0],
        "rates": [12.3, 28.98, 60.66],
        "default_class": "High",
    },

    "spinach": {
        "unit": "mL CO2/kg/h",
        "reference_source": "UC Davis Postharvest Research and Extension Center",
        "temperatures_c": [0.0, 5.0, 10.0, 15.0, 20.0],
        "rates": [10.0, 23.0, 55.0, 89.0, 114.0],
        "default_class": "Very High",
    },

    "broccoli": {
        "unit": "mL CO2/kg/h",
        "reference_source": "University of Florida postharvest reference",
        "temperatures_c": [0.0, 5.0, 10.0, 15.0, 20.0],
        "rates": [21.0, 34.0, 81.0, 170.0, 300.0],
        "default_class": "Very High",
    },

    "cabbage": {
        "unit": "mL CO2/kg/h",
        "reference_source": "University of Florida postharvest reference",
        "temperatures_c": [0.0, 5.0, 10.0, 15.0, 20.0, 25.0],
        "rates": [5.0, 11.0, 18.0, 28.0, 42.0, 62.0],
        "default_class": "Low",
    },

    "onion": {
        "unit": "mL CO2/kg/h",
        "reference_source": "MAP reference data",
        "temperatures_c": [0.0, 10.0, 20.0],
        "rates": [2.0, 4.0, 5.0],
        "default_class": "Low",
    },

    "cucumber": {
        "unit": "mL CO2/kg/h",
        "reference_source": "MAP reference data",
        "temperatures_c": [0.0, 10.0, 20.0],
        "rates": [3.0, 7.0, 8.0],
        "default_class": "Low",
    },
}


def get_respiration_profile(commodity: str):
    """
    Return the reference respiration profile for a commodity.
    """
    return RESPIRATION_DATABASE.get(commodity.strip().lower())