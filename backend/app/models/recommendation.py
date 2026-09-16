from pydantic import BaseModel
from typing import List


class PackagingAlternative(BaseModel):
    material: str
    structure: str
    packaging_type: str
    score: float
    reason: str


class PackagingRecommendation(BaseModel):
    commodity: str

    recommended_material: str
    structure: str
    packaging_type: str

    compatibility_score: float

    thickness: str
    barrier_level: str
    otr: str
    wvtr: str

    sealability: str
    mechanical_strength: str
    gas_permeability: str
    map_suitability: str

    sustainability_score: float
    cost_score: float

    reasoning: List[str]
    alternatives: List[PackagingAlternative]

    disclaimer: str