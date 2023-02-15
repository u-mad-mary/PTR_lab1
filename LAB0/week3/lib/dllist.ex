defmodule DLList do

  def create_dllist(elements) do
    start_node = spawn_nodes(elements, nil)
    %{start_node: start_node}
  end

  def spawn_nodes([], _left_node) do
    nil
  end

  def spawn_nodes([first | rest], left_node) do
    current_node = spawn(fn -> handle_list(first, left_node, nil) end)
    next_node = spawn_nodes(rest, current_node)
    send(current_node, {:update_right, next_node})
    current_node
  end

  def handle_list(current_node, left_node, right_node) do
    receive do
      {:update_right, new_right_node} ->
        handle_list(current_node, left_node, new_right_node)

      {:traverse, node_pid, list} ->
        if right_node == nil, do: send(node_pid, {list ++ [current_node]}),
        else: send(right_node, {:traverse, node_pid, list ++ [current_node]})

      {:inverse, node_pid, list} ->
        if right_node == nil, do: send(node_pid, {[current_node | list]}),
        else: send(right_node, {:inverse, node_pid, [current_node | list]})
    end
    handle_list(current_node, left_node, right_node)
  end

  def traverse(list) do
    start_node_pid = list.start_node
    send(start_node_pid, {:traverse, self(), []})

    receive do
      element ->
        element
    end
  end

  def inverse(list) do
    start_node_pid = list.start_node
    send(start_node_pid, {:inverse, self(), []})

    receive do
      element ->
        element
    end
  end
end

# list = DLList.create_dllist([1,2,3])
# DLList.traverse(list)
# DLList.inverse(list)
