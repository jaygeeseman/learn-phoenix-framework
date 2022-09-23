defmodule LiveCounterWeb.Counter do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :counter_value, 0)}
  end

  def handle_event("counter-increment", _, socket) do
    {:noreply, update(socket, :counter_value, &(&1 + 1))}
  end

  def handle_event("counter-decrement", _, socket) do
    {:noreply, update(socket, :counter_value, &(&1 - 1))}
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
