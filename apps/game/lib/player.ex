defmodule Game.Player do
  @moduledoc """
  Player
  """
  alias Game.{
    Settings,
    Player,
    Dice
  }

  @type t :: %Player{
          user: String.t(),
          health: integer(),
          tokens: integer(),
          turns: integer(),
          rolled: boolean(),
          dices: %{}
        }
  defstruct user: nil, health: 0, tokens: 0, dices: %{}, turns: 0, rolled: false

  @spec new(String.t(), Settings.t()) :: Player.t()
  def new(user, settings) do
    %Player{user: user}
    |> update_health(settings.health)
    |> update_tokens(settings.tokens)
    |> set_dices(settings.dices)
  end

  @spec update(Player.t(), map()) :: Player.t()
  def update(player, attrs) do
    Map.merge(player, attrs)
  end

  @spec update_health(Player.t(), integer()) :: Player.t()
  def update_health(player, amount) do
    %{player | health: player.health + amount}
  end

  @spec update_tokens(Player.t(), integer()) :: Player.t()
  def update_tokens(player, amount) do
    %{player | tokens: player.tokens + amount}
  end

  @spec update_turns(Player.t(), integer()) :: Player.t()
  def update_turns(player, amount) do
    %{player | turns: player.turns + amount}
  end

  @spec set_dices(Player.t(), integer()) :: Player.t()
  def set_dices(player, amount) do
    %{player | dices: Enum.into(1..amount, %{}, fn index -> {index, %Dice{}} end)}
  end

  @spec get_dice(Player.t(), integer()) :: Dice.t()
  def get_dice(player, index) do
    Map.get(player.dices, index)
  end

  @spec update_dices(Player.t(), fun()) :: Player.t()
  def update_dices(player, fun) do
    dices =
      player.dices
      |> Enum.into(%{}, fn {index, dice} -> {index, fun.(dice)} end)

    %{player | dices: dices}
  end

  @spec update_dice(Player.t(), integer(), fun()) :: Player.t()
  def update_dice(player, index, fun) do
    dice =
      player.dices
      |> Map.get(index)
      |> fun.()

    %{player | dices: Map.put(player.dices, index, dice)}
  end
end