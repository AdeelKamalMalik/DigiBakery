import { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";

import Orders from "/app/components/orders";

const element = document.querySelector("[data-order-table]");
if (element) {
  createRoot(element).render(<Orders />);
}
