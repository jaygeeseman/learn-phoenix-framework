defmodule LiveCounterWeb.Counter do
@moduledoc """
Nothing to see here.
"""
  use Phoenix.LiveView
  alias LiveCounter.Count
  alias Phoenix.PubSub
  alias LiveCounter.Presence

  @topic Count.topic
  @presence_topic "presence"

  def mount(_params, _session, socket) do
    PubSub.subscribe(LiveCounter.PubSub, @topic)

    Presence.track(self(), @presence_topic, socket.id, %{})
    LiveCounterWeb.Endpoint.subscribe(@presence_topic)

    initial_present =
      Presence.list(@presence_topic)
      |> map_size()

    {:ok, assign(socket, counter_value: Count.current(), present: initial_present)}
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

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
      ) do
    new_present = present + map_size(joins) - map_size(leaves)

    {:noreply, assign(socket, :present, new_present)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @counter_value %></h1>
      <button phx-click="counter-decrement">-</button>
      <button phx-click="counter-increment">+</button>
      <h1>Current users: <%= @present %></h1>
    </div>
    """
  end
end
