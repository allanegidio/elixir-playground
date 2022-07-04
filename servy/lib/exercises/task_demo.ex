defmodule TaskDemo do
  alias Servy.VideoCam
  alias Servy.Fetcher

  # 1 - Nesse primeiro caso temos o uso do spawn para pegar a mensagem que e enviada para o processo.
  #     Porem nesse exemplo existe um problema, o receive e thread block e como o snapshop esta gerando em background com um timer aleatorio
  #     O resultado esta vindo desincronizado. O processo da Cam-2 pode ser feito primeiro e ser recebido no receive.

  # def main() do
  #   process_parent = self()

  #   spawn(fn -> send(process_parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
  #   spawn(fn -> send(process_parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
  #   spawn(fn -> send(process_parent, {:result, VideoCam.get_snapshot("cam-3")}) end)

  #   snapshot1 =
  #     receive do
  #       {:result, filename} -> filename
  #     end

  #   snapshot2 =
  #     receive do
  #       {:result, filename} -> filename
  #     end

  #   snapshot3 =
  #     receive do
  #       {:result, filename} -> filename
  #     end

  #   [snapshot1, snapshot2, snapshot3]
  # end

  # 2 - Nesse exemplo eu uso o modulo Fetcher onde ele usa o spawn em uma funcao anonima e retorna o process id
  #     Dessa forma no get result, posso fazer o check do pattern matching com o process id e pegar o resultado do processo que gerou o snapshot
  #     Sendo possivel agora ordernar os snapshots pq como sabemos o result e thread block e ele ira aguardar o resultado ordenado dos processos conforme o codigo

  def main() do
    pid1 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-1") end)
    pid2 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-2") end)
    pid3 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-3") end)

    snapshot1 = Fetcher.get_result(pid1)
    snapshot2 = Fetcher.get_result(pid2)
    snapshot3 = Fetcher.get_result(pid3)

    [snapshot1, snapshot2, snapshot3]
  end

  # 3 - Nesse exemplo eu deixo de trabalhar com minha implementacao de Fetcher e passo utilizar o padrao do Elixir, a lib chamada Task
  #     Ao invez de trabalhar com o PID, a task trabalha com ela mesma, identificando a task e aguardando o resultado do processo em paralelo a outra thread.
  #     Eu utilizou o atom :infinity nesse caso porque como o resultado do snapshot e aleatorio, as vezes supera os 5ms padrao da biblioteca Task.Supervised

  # def main() do
  #   task1 = Task.async(fn -> VideoCam.get_snapshot("cam-1") end)
  #   task2 = Task.async(fn -> VideoCam.get_snapshot("cam-2") end)
  #   task3 = Task.async(fn -> VideoCam.get_snapshot("cam-3") end)

  #   snapshot1 = Task.await(task1, :infinity)
  #   snapshot2 = Task.await(task2, :infinity)
  #   snapshot3 = Task.await(task3, :infinity)

  #   [snapshot1, snapshot2, snapshot3]
  # end

  # 4 - Um exemplo elegante utilizando Pipe e a lib Enum

  # def main() do
  #   result =
  #     ["cam-3", "cam-2", "cam-1"]
  #     |> Enum.map(fn snapshot -> Task.async(fn -> VideoCam.get_snapshot(snapshot) end) end)
  #     |> Enum.map(fn task -> Task.await(task, :infinity) end)

  #   result
  # end

  # 5 - Um exemplo rodando varias tasks ao mesmo tempo e recebendo o resultado da lista de tasks

  # def main() do
  #   tasks = [
  #     Task.async(fn -> VideoCam.get_snapshot("cam-3") end),
  #     Task.async(fn -> VideoCam.get_snapshot("cam-2") end),
  #     Task.async(fn -> VideoCam.get_snapshot("cam-1") end)
  #   ]

  #   Task.await_many(tasks, :infinity)
  # end

  # 6 - Exemplo usando comprehensions

  # def main() do
  #   snapshots = ["cam-3", "cam-2", "cam-1"]

  #   tasks =
  #     for snapshot <- snapshots, into: [] do
  #       Task.async(fn -> VideoCam.get_snapshot(snapshot) end)
  #     end

  #   Task.await_many(tasks, :infinity)
  # end
end
