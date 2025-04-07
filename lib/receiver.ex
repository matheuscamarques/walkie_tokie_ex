defmodule WalkieTokie.Receiver do
  use GenServer

  @aplay_path "/usr/bin/aplay"
  @aplay_args [
    "--quiet",
    "-r", "44100",
    "-f", "S16_LE",
    "-c", "2",
    "-t", "raw",
    "--period-size=16",
    "--buffer-size=32",
    "-"
  ]

  ## Public API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def send_chunk(chunk) when is_binary(chunk) do
    GenServer.cast(__MODULE__, {:audio_chunk, chunk})
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end

  ## GenServer Callbacks

  @impl true
  def init(:ok) do
    port = Port.open({:spawn_executable, @aplay_path}, [
      :binary,
      :exit_status,
      args: @aplay_args
    ])

    IO.puts("[Receiver] Porta para aplay aberta.")
    {:ok, port}
  end

  @impl true
  def handle_cast({:audio_chunk, chunk}, port) do
    Port.command(port, chunk)
    {:noreply, port}
  end

  @impl true
  def handle_cast(:stop, port) do
    IO.puts("[Receiver] Fechando porta...")
    Port.close(port)
    {:stop, :normal, port}
  end
end
