defmodule LiveCounterWeb.Counter do
@moduledoc """
Nothing to see here.
"""
  use Phoenix.LiveView
  alias LiveCounter.Count
  alias Phoenix.PubSub

  @topic Count.topic

  def mount(_params, _session, socket) do
    PubSub.subscribe(LiveCounter.PubSub, @topic)
    {:ok, assign(socket, :counter_value, Count.current)}
  end

  def handle_event("counter-increment", _, socket) do
    {:noreply, assign(socket, counter_value: Count.counter_increment())}
  end

  def handle_event("counter-decrement", _, socket) do
    {:noreply, assign(socket, counter_value: Count.counter_decrement())}
  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, counter_value: count)}
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
