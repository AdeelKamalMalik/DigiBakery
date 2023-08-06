import { useEffect, useState } from "react";
import Table from "./table";
import Loader from '../shared/loader';

const fetchOrders = async () => {
  const response = await fetch("/api/orders.json");
  const data = await response.json();
  return data;
};

export default () => {
  const [orders, setOrders] = useState([]);
  const [isLoading, setIsLoading] = useState(true)

  const handleFulfillOrder = async (orderId) => {
    const response = await fetch(`/api/orders/${orderId}/fulfill`, { method: "PUT" });
    if (response.ok) {
      const updatedOrder = orders.find((order) => order.id === orderId);
      if (updatedOrder) {
        updatedOrder.fulfilled = true;
        setOrders([...orders]);
      }
    } else {
      console.error("Failed to fulfill the order");
    }
  };


  const handleSort = (column) => {
    let sortedOrders = []
    if(column == 'pick_up_at')
      sortedOrders = [...orders].sort((a, b) => new Date(a.pick_up_at) - new Date(b.pick_up_at));
    else if (column == 'customer_name')
      sortedOrders = [...orders].sort((a, b) => a.customer_name.localeCompare(b.customer_name));
    else
      sortedOrders = [...orders].sort((a, b) => a.id - b.id);

    setOrders(sortedOrders)
  }

  useEffect(() => {
    const go = async () => {
      try {
        const orders = await fetchOrders();
        setOrders(orders);
        setIsLoading(false);
      } catch (er) {
        setIsLoading(false);
        alert(`uh oh! ${er}`);
      }
    };
    go();
  }, []);

  return (
    <div>
      {isLoading ? <Loader /> : (<Table
          orders={orders}
          onFulfillOrder={handleFulfillOrder}
          handleSort={handleSort}
         />
        )
      }
    </div>
  );
};
