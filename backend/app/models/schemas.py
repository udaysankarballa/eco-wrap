from pydantic import BaseModel, Field


class PackagingRequest(BaseModel):
    commodity: str = Field(..., min_length=1)

    moisture: float = Field(..., ge=0, le=100)
    ph: float = Field(..., ge=0, le=14)
    fat: float = Field(..., ge=0, le=100)

    shelf_life: int = Field(..., ge=1)

    storage_type: str = Field(..., min_length=1)
    temperature: float
    humidity: float = Field(..., ge=0, le=100)

    transport_mode: str = Field(..., min_length=1)
    transport_duration: int = Field(..., ge=0)

    use_lab_values: bool = False