import { createConsumer } from "@rails/actioncable"

createConsumer().subscriptions.create({ channel: "CookiesChannel" }, {
  connected() {
    console.log('connected to cookies channel')
  },

  disconnected() {
    console.log('disconnected from cookies channel')
  },

  received(data) {
    document.querySelector(`#cookies${data.id}`).innerHTML = data.cookie;
    if(!data.oven_busy) {
      let inputElement = document.createElement('input');
      inputElement.type = 'hidden';
      inputElement.name = 'authenticity_token';
      inputElement.value = document.querySelector('meta[name="csrf-token"]').content;
      let target = document.querySelector(`#oven${data.oven_id}actions`)
      target.innerHTML = data.oven_actions
      target.firstChild.appendChild(inputElement)
    }
  }
});
