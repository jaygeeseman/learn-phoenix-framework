defmodule LiveCounter.Count do
@moduledoc """
Keeps track of the state information.
"""

  use GenServer

  alias Phoenix.PubSub

  @name :count_server

  @start_value 0

  # ------- External API (runs in client process) -------

  def topic do
    "count"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def counter_increment() do
    GenServer.call @name, :counter_increment
  end

  def counter_decrement() do
    GenServer.call @name, :counter_decrement
  end

  def current() do
    GenServer.call @name, :counter_current
  end

  def init(start_count) do
    {:ok, start_count}
  end

  # ------- Implementation (runs in GenServer process) -------

  def handle_call(:counter_current, _from, count) do
    {:reply, count, count}
  end

  def handle_call(:counter_increment, _from, count) do
    update_counter(count, +1)
  end

  def handle_call(:counter_decrement, _from, count) do
    update_counter(count, -1)
  end

  defp update_counter(count, change) do
    new_count = count + change
    PubSub.broadcast(LiveCounter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end
end
