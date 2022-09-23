defmodule LiveCounterWeb.Counter do
@moduledoc """
Nothing to see here.
"""
  use Phoenix.LiveView

  @topic "live"

  def mount(_params, _session, socket) do
    LiveCounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :counter_value, 0)}
  end

  def handle_event("counter-increment", _, socket) do
    new_state = update(socket, :counter_value, &(&1 + 1))
    LiveCounterWeb.Endpoint.broadcast_from(self(), @topic, "counter-increment", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("counter-decrement", _, socket) do
    new_state = update(socket, :counter_value, &(&1 - 1))
    LiveCounterWeb.Endpoint.broadcast_from(self(), @topic, "counter-decrement", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, counter_value: msg.payload.counter_value)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @counter_value %></h1>
      <button phx-click="counter-decrement">-</button>
      <button phx-click="counter-increment">+</button>
    </div>
    """
  end
end
