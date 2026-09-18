export async function userHandler(request, response) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 2_000);
  try {
    const upstream = await fetch(
      `https://users.example.test/${request.params.userId}`,
      { signal: controller.signal },
    );
    if (!upstream.ok) {
      response.status(upstream.status).end();
      return;
    }
    response.json(await upstream.json());
  } finally {
    clearTimeout(timeout);
  }
}

