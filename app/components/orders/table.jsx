import {useState} from 'react'

const OrderTable = (props) => {
  const { orders, onFulfillOrder, handleSort } = props
  return (
  <table className="table orders-table">
    <thead>
      <tr>
        <th className="text-decoration-underline cursor-pointer"
          onClick={() => handleSort("id")}>
          Order #</th>
        <th>Ordered at</th>
        <th className="text-decoration-underline cursor-pointer"
           onClick={() => handleSort("pick_up_at")}>
          Pick up at</th>
        <th className="text-decoration-underline cursor-pointer"
          onClick={() => handleSort("customer_name")}>
          Customer Name</th>
        <th>Item</th>
        <th>Qty</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      {orders.map((order) => (
        <OrderRow 
          key={order.id}
          order={order}
          onFulfillOrder={onFulfillOrder}
        />
      ))}
    </tbody>
  </table>);
}

const OrderRow = (props) => {
  const { order, onFulfillOrder } = props
  const [fulFillingOrder, setfulFillingOrder] = useState('')

  const handleClick = (or) => {
    setfulFillingOrder(or.id)
    onFulfillOrder(or.id)
  }
  
  return (
    <tr>
      <td>{order.id}</td>
      <td>{formatDate(order.created_at)}</td>
      <td>{formatDate(order.pick_up_at)}</td>
      <td>{order.customer_name}</td>
      <td>{order.item}</td>
      <td>{order.quantity}</td>
      <td>{order.fulfilled ? `Fulfilled` : `In progress`}</td>
      <td>
        { !order.fulfilled && (
          <button 
            className="fulfil-btn btn btn-outline-success btn-sm"
            onClick={() => handleClick(order)}
            disabled={fulFillingOrder == order.id}
            >Fulfill order
          </button>
        )}
      </td>
    </tr>
  );
};

const formatDate = (dateString) => {
  let date = new Date(dateString);
  return date.toLocaleDateString();
};

export default OrderTable;
