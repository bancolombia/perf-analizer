defmodule MnesiaAdapter do
    @moduledoc """
    Provides a high-level interface for interacting with the Mnesia database.
  
    This module encapsulates common Mnesia operations such as starting the database,
    creating tables, writing records, and reading data. It also includes logging
    for better observability and wraps asynchronous operations in Tasks.
    """
  
    require Logger
    alias :mnesia, as: Mnesia
  
    @type table_name :: atom()
    @type table_attributes :: [{atom(), atom()}]
    @type record :: tuple()
    @type result :: :ok | {:error, term()}
  
    @doc """
    Starts the Mnesia database.
  
    This function attempts to start Mnesia and logs the result. If Mnesia
    is already running, it returns :ok.
  
    Returns:
      * `:ok` if Mnesia started successfully or was already running
      * `{:error, reason}` if there was an error starting Mnesia
    """
    @spec start() :: result()
    def start do
      case Mnesia.start() do
        :ok ->
          Logger.info("#{__MODULE__}: Mnesia started successfully")
          :ok
  
        {:error, {:already_started, _node}} ->
          Logger.info("#{__MODULE__}: Mnesia already started")
          :ok
  
        {:error, reason} ->
          Logger.error("#{__MODULE__}: Error starting Mnesia: #{inspect(reason)}")
          {:error, reason}
      end
    end
  
    @doc """
    Creates a new Mnesia table.
  
    This function creates a new table in Mnesia with the given name and attributes.
    It logs the result of the operation.
  
    Parameters:
      * `table`: The name of the table to create (atom)
      * `attributes`: A list of attribute definitions for the table
  
    Returns:
      * `:ok` if the table was created successfully
      * `{:error, reason}` if there was an error creating the table
    """
    @spec create_table(table_name(), table_attributes()) :: result()
    def create_table(table, attributes) when is_atom(table) and is_list(attributes) do
      Logger.info("#{__MODULE__}: Creating Mnesia table: #{table}")
  
      case Mnesia.create_table(table, attributes: attributes) do
        {:atomic, :ok} ->
          Logger.info("#{__MODULE__}: Mnesia table #{table} created successfully")
          :ok
  
        {:aborted, reason} ->
          Logger.error("#{__MODULE__}: Error creating Mnesia table #{table}: #{inspect(reason)}")
          {:error, reason}
      end
    end
  
    @doc """
    Writes a record to Mnesia asynchronously.
  
    This function writes the given record to Mnesia using a dirty write operation.
    The operation is wrapped in a Task for asynchronous execution.
  
    Parameters:
      * `record`: The record to write to Mnesia (tuple)
  
    Returns:
      * A `Task` that will resolve to `:ok` if the write was successful,
        or `{:error, reason}` if there was an error
    """
    @spec write(record()) :: Task.t()
    def write(record) do
      Task.async(fn ->
        Logger.info("#{__MODULE__}: Writing data to Mnesia: #{inspect(record)}")
  
        case Mnesia.dirty_write(record) do
          :ok ->
            Logger.info("#{__MODULE__}: Data written to Mnesia successfully")
            :ok
  
          {:error, reason} ->
            Logger.error("#{__MODULE__}: Error writing data to Mnesia: #{inspect(reason)}")
            {:error, reason}
        end
      end)
    end
  
    @doc """
    Reads a record from Mnesia asynchronously.
  
    This function reads a record from Mnesia using a dirty read operation.
    The operation is wrapped in a Task for asynchronous execution.
  
    Parameters:
      * `key`: The key to read from Mnesia (can be a tuple for composite keys)
  
    Returns:
      * A `Task` that will resolve to `{:ok, [record]}` if the read was successful,
        `{:ok, []}` if no record was found, or `{:error, reason}` if there was an error
    """
    @spec read(record()) :: Task.t()
    def read(key) do
      Task.async(fn ->
        Logger.info("#{__MODULE__}: Reading data from Mnesia: #{inspect(key)}")
  
        case Mnesia.dirty_read(key) do
          [] ->
            Logger.info("#{__MODULE__}: No data found in Mnesia")
            {:ok, []}
  
          result when is_list(result) ->
            Logger.info("#{__MODULE__}: Data read from Mnesia successfully: #{inspect(result)}")
            {:ok, result}
  
          {:error, reason} ->
            Logger.error("#{__MODULE__}: Error reading data from Mnesia: #{inspect(reason)}")
            {:error, reason}
        end
      end)
    end
  end