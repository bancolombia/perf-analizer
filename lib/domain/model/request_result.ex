defmodule DistributedPerformanceAnalyzer.Domain.Model.RequestResult do
  @moduledoc """
  TODO Result of a single request
  """
  @enforce_keys [:label, :thread_name, :url, :sent_bytes, :connect]

  @allowed_keys [
    "start",
    "time_stamp",
    "label",
    "thread_name",
    "grp_threads",
    "all_threads",
    "url",
    "elapsed",
    "response_code",
    "response_message",
    "data_type",
    "success",
    "failure_message",
    "bytes",
    "sent_bytes",
    "latency",
    "idle_time",
    "connect",
    "received_bytes",
    "content_type"
  ]

  @type t :: %__MODULE__{
          start: float(),
          time_stamp: float(),
          label: String.t(),
          thread_name: String.t(),
          grp_threads: integer(),
          all_threads: integer(),
          url: String.t(),
          elapsed: float(),
          response_code: integer(),
          response_message: String.t(),
          data_type: String.t(),
          success: boolean(),
          failure_message: String.t(),
          bytes: integer(),
          sent_bytes: integer(),
          latency: float(),
          idle_time: float(),
          connect: integer(),
          received_bytes: String.t(),
          content_type: String.t()
        }

  defstruct start: 0,
            time_stamp: 0,
            label: "",
            thread_name: "",
            grp_threads: 0,
            all_threads: 0,
            url: "",
            elapsed: 0,
            response_code: 0,
            response_message: "",
            data_type: "",
            success: false,
            failure_message: "",
            bytes: 0,
            sent_bytes: 0,
            latency: 0,
            idle_time: 0,
            connect: 0,
            received_bytes: "",
            content_type: ""

  @spec new(String.t(), String.t(), String.t(), integer(), integer(), integer()) ::
          RequestResult.t()
  def new(label, thread_name, url, sent_bytes, connect, concurrency) do
    %__MODULE__{
      start: :erlang.monotonic_time(:millisecond),
      time_stamp: System.os_time(:millisecond),
      label: label,
      thread_name: thread_name,
      grp_threads: concurrency,
      all_threads: concurrency,
      url: url,
      sent_bytes: sent_bytes,
      connect: connect
    }
  end
end
