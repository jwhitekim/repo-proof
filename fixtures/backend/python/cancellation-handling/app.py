import asyncio
from pathlib import Path


async def _write_export(handle) -> None:
    for chunk in range(100):
        await asyncio.sleep(0.1)
        handle.write(f"row-{chunk}\n".encode())


async def export_handler(destination: Path) -> dict[str, str]:
    """The HTTP request has a short deadline but the export task is shielded."""
    handle = destination.open("wb")
    task = asyncio.create_task(_write_export(handle))
    try:
        await asyncio.wait_for(asyncio.shield(task), timeout=0.2)
    except TimeoutError:
        return {"status": "timed-out"}
    handle.close()
    return {"status": "complete"}

