import sqlite3


def user_handler(user_id: int) -> dict[str, object]:
    """One handler invocation corresponds to one HTTP request."""
    connection = sqlite3.connect("users.db")
    row = connection.execute(
        "SELECT id, name FROM users WHERE id = ?", (user_id,)
    ).fetchone()
    if row is None:
        return {"status": 404}
    return {"status": 200, "id": row[0], "name": row[1]}

