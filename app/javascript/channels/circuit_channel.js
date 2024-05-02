import consumer from "channels/consumer";

consumer.subscriptions.create("CircuitChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.debug("Connected to CircuitChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.debug("Disconnected from CircuitChannel");
  },

  received(data) {
    const circuit_json = data["circuit_json"];

    // Called when there's incoming data on the websocket for this channel
    const circuit_el = document.getElementById("circuit");
    circuit_el.dataset.json = circuit_json;

    const circuit_json_el = document.getElementById("circuit_json");
    circuit_json_el.innerText = circuit_json;
  },

  update: function (circuit_json) {
    return this.perform("update", { circuit_json: circuit_json });
  },
});
