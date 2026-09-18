import json
from urllib.request import urlopen


async def exchange_rate_handler(currency: str) -> dict[str, float]:
    """Called directly by an ASGI route for each incoming request."""
    with urlopen(f"https://rates.example.test/{currency}", timeout=5) as response:
        payload = json.load(response)
    return {"rate": float(payload["rate"])}

