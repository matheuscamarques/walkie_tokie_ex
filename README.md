Here's a clean and professional `README.md` in English, without emojis, suitable for your GitHub project based on the provided Elixir module:

---

# WalkieTokie

**WalkieTokie** is a simple peer-to-peer audio transfer system written in Elixir using `GenServer`. It simulates a push-to-talk (walkie-talkie) interaction over a distributed Elixir node network.

## Features

- State machine to control audio transmission lifecycle
- Peer-to-peer audio streaming using `arecord` and `aplay`
- Audio transmission in raw format using Elixir `Port`
- Support for start/stop talking commands
- Simple fault tolerance with automatic reconnection attempts

## Architecture

The application consists of two main components:

### Sender (`WalkieTokie.Sender`)
Handles:

- Connecting to a remote Elixir node
- Capturing microphone audio using `arecord`
- Sending raw audio chunks to the remote node
- Finite state machine controlling the lifecycle:
  - `:try_connection`
  - `:try_transfer_request`
  - `:start_chunk_file`
  - `:start_transfer`
  - `:transfer_chunk`
  - `:completed`
  - `:start_exit`
  - `:exit`

### Receiver (`WalkieTokie.Receiver`)
Handles:

- Receiving audio chunks from a remote sender
- Playing audio in real time using `aplay`
- Spawning a `Port` for handling audio output

## Usage

1. Start the sender node:

```elixir
WalkieTokie.Sender.start_link([
  node_target: :"peer1@your-hostname",
  audio_device: "plughw:1,0"
])
```

2. Start and stop talking:

```elixir
WalkieTokie.Sender.start_talking(pid)
WalkieTokie.Sender.stop_talking(pid)
```

3. On the receiver node, make sure `WalkieTokie.Receiver` is available and can respond to `:rpc.call/4`.

## Requirements

- Elixir >= 1.14
- Two connected Elixir nodes (distributed Erlang)
- ALSA-compatible system with:
  - `arecord` for audio capture
  - `aplay` for audio playback

## Audio Format

- Sample Rate: 44100 Hz
- Format: Signed 16-bit Little Endian (`S16_LE`)
- Channels: Stereo
- Output Type: Raw PCM

## How it works

1. The sender attempts to connect to the target node.
2. Upon connection, it starts capturing audio using `arecord`.
3. Captured chunks are streamed to the receiver via RPC calls.
4. The receiver plays the audio in real-time using `aplay`.

## License

MIT License

---