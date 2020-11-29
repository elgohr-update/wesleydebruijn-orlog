defmodule Game.Dice do
  @moduledoc """
  Dice
  """
  alias Game.Dice

  @faces [
    Dice.Face.MeleeAttack.get(),
    Dice.Face.MeleeBlock.get(),
    Dice.Face.RangedAttack.get(),
    Dice.Face.RangedBlock.get(),
    Dice.Face.StealToken.get()
  ]

  @type t :: %Dice{
          face: Game.Dice.Face.t(),
          tokens: integer(),
          locked: boolean(),
          keep: boolean()
        }
  defstruct face: nil, tokens: 0, locked: false, keep: false

  @spec roll(Game.Dice.t()) :: Game.Dice.t()
  def roll(%{keep: true} = dice), do: dice

  def roll(dice) do
    %{dice | face: Enum.random(@faces), tokens: Enum.random(0..1)}
  end

  @spec keep(Game.Dice.t()) :: Game.Dice.t()
  def keep(dice), do: %{dice | keep: true}

  @spec swap(Game.Dice.t()) :: Game.Dice.t()
  def swap(%{locked: true} = dice), do: dice
  def swap(dice), do: %{dice | keep: !dice.keep}

  @spec lock(Game.Dice.t()) :: Game.Dice.t()
  def lock(%{keep: false} = dice), do: dice
  def lock(dice), do: %{dice | locked: true}

  @spec unlock(Game.Dice.t()) :: Game.Dice.t()
  def unlock(dice), do: %{dice | locked: false}
end
