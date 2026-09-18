export function formatCurrency(amount, currency) {
  return new Intl.NumberFormat("en", { style: "currency", currency }).format(amount);
}
