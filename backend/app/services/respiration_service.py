"""
ECO WRAP - Respiration Estimation Service

Estimates commodity respiration rate from reference data
using linear interpolation between known temperature points.

Output unit:
    mL CO2 / kg / h

This is an AI-assisted prototype estimate and should not be
treated as a laboratory measurement.
"""

from app.data.respiration_database import get_respiration_profile


def _linear_interpolate(
    x1: float,
    y1: float,
    x2: float,
    y2: float,
    x: float,
) -> float:
    """
    Calculate y at x using linear interpolation.

    Formula:
        y = y1 + (x - x1) * (y2 - y1) / (x2 - x1)
    """

    if x2 == x1:
        return y1

    return y1 + ((x - x1) * (y2 - y1) / (x2 - x1))


def estimate_respiration_rate(
    commodity: str,
    temperature_c: float,
) -> dict:
    """
    Estimate respiration rate for a commodity at a given temperature.

    The reference database contains respiration measurements at
    selected temperatures. If the requested temperature falls
    between two reference points, linear interpolation is used.

    If the temperature is outside the reference range, the nearest
    boundary value is used rather than extrapolating beyond the
    available reference data.
    """

    profile = get_respiration_profile(commodity)

    if profile is None:
        return {
            "available": False,
            "commodity": commodity,
            "estimated_rate": None,
            "unit": "mL CO2/kg/h",
            "respiration_class": "Unknown",
            "method": "No reference profile available",
        }

    temperatures = profile["temperatures_c"]
    rates = profile["rates"]

    if len(temperatures) != len(rates):
        raise ValueError(
            f"Invalid respiration reference data for '{commodity}'."
        )

    temperature = float(temperature_c)

    # ---------------------------------------------------------------
    # Below the lowest reference temperature
    # ---------------------------------------------------------------
    if temperature <= temperatures[0]:
        estimated_rate = rates[0]
        method = "Lower reference boundary"

    # ---------------------------------------------------------------
    # Above the highest reference temperature
    # ---------------------------------------------------------------
    elif temperature >= temperatures[-1]:
        estimated_rate = rates[-1]
        method = "Upper reference boundary"

    # ---------------------------------------------------------------
    # Interpolate between two reference temperatures
    # ---------------------------------------------------------------
    else:
        estimated_rate = rates[0]
        method = "Linear interpolation"

        for index in range(len(temperatures) - 1):
            t1 = temperatures[index]
            t2 = temperatures[index + 1]

            if t1 <= temperature <= t2:
                r1 = rates[index]
                r2 = rates[index + 1]

                estimated_rate = _linear_interpolate(
                    x1=t1,
                    y1=r1,
                    x2=t2,
                    y2=r2,
                    x=temperature,
                )
                break

    respiration_class = _classify_respiration(estimated_rate)

    return {
        "available": True,
        "commodity": commodity,
        "estimated_rate": round(estimated_rate, 2),
        "unit": profile["unit"],
        "temperature_c": round(temperature, 2),
        "respiration_class": respiration_class,
        "method": method,
        "reference_source": profile["reference_source"],
    }


def _classify_respiration(rate: float) -> str:
    """
    Convert the estimated numerical respiration rate into
    a qualitative class used by the recommendation engine.

    These thresholds are prototype classification thresholds,
    not universal scientific standards.
    """

    if rate < 10:
        return "Low"

    if rate < 40:
        return "Medium"

    if rate < 100:
        return "High"

    return "Very High"