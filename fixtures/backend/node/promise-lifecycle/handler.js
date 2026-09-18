const auditClient = {
  async record(orderId) {
    const response = await fetch("https://audit.example.test/events", {
      method: "POST",
      body: JSON.stringify({ orderId }),
      signal: AbortSignal.timeout(2_000),
    });
    if (!response.ok) throw new Error("audit rejected");
  },
};

export function submitOrderHandler(request, response) {
  auditClient.record(request.body.orderId);
  response.status(202).end();
}
