import consumer from "channels/consumer";
import { Complex } from "@qni/common";

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
    const modified_circuit_json = data["modified_circuit_json"];
    const step = data["step"];

    // Called when there's incoming data on the websocket for this channel
    const circuit_el = document.getElementById("circuit");
    circuit_el.dataset.json = modified_circuit_json;

    circuit_el.steps.forEach((each, index) => {
      if (index === step) {
        each.active = true;
      } else {
        each.active = false;
      }
    });

    const circuit_json_el = document.getElementById("circuit-json");
    circuit_json_el.innerText = circuit_json;

    const circle_notation_el = document.getElementById("circle-notation");
    const state_vector = data["state_vector"];
    const qubit_count = Math.log2(data["state_vector"].length);

    circle_notation_el.qubitCount = qubit_count;
    state_vector.nqubit = qubit_count;
    let circle_notation_amplitudes = {};

    state_vector.forEach((value, index) => {
      const amplitude = new Complex(value["real"], value["imag"]);
      circle_notation_amplitudes[index] = amplitude;
    });

    circle_notation_el.setAmplitudes(circle_notation_amplitudes);
  },

  update: function (circuit_json) {
    return this.perform("update", { circuit_json: circuit_json });
  },
});
