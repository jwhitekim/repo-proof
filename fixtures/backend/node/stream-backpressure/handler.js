import { createReadStream } from "node:fs";

export function downloadHandler(_request, response) {
  const source = createReadStream("large-export.ndjson");
  source.on("data", (chunk) => {
    response.write(chunk);
  });
  source.on("end", () => response.end());
  source.on("error", (error) => response.destroy(error));
}

