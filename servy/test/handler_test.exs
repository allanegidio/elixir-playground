defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 60\r
           \r
           🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 395\r
    \r
    🎉🎉🎉🎉🎉<h1>All The Bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 17\r
           \r
           No /bigfoot here!
           """
  end

  test "GET /bears?id=1" do
    request = """
    GET /bears?id=1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 111\r
    \r
    🎉🎉🎉🎉🎉<h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 111\r
    \r
    🎉🎉🎉🎉🎉<h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "DELETE /bears/1" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Deleting a bear is forbidden!
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 60\r
           \r
           🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 359\r
    \r
    🎉🎉🎉🎉🎉<h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe as one great dewdrop,
    striped and dotted with continents and islands, flying
    through space with other stars all singing and shining
    together as one, the whole universe appears as an infinite
    storm of beauty. -- John Muir
    </blockquote>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /pages/faq" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 692\r
    \r
    🎉🎉🎉🎉🎉<h1>FrequentlyAskedQuestions</h1>
    <ul>
      <li>
        <p><strong>HaveyoureallyseenBigfoot?</strong></p>
        <p>Yes!Inthis<ahref=\"https://www.youtube.com/watch?v=v77ijOO8oAk\">totallybelievablevideo </a>! </p> </li> <li>
            <p><strong>No,ImeanseenBigfoot<em>ontherefuge</em>?</strong></p>
            <p>Oh!Notyet,butwe’re<em>stilllooking</em>…</p>
      </li>
      <li>
        <p><strong>Canyoujustshowmesomecode?</strong></p>
        <p>Sure!Here’ssomeElixir:</p>
        <pre><codeclass=\"elixir\">[&quot;Bigfoot&quot;,&quot;Yeti&quot;,&quot;Sasquatch&quot;]|&gt;Enum.random()</code></pre>
      </li>
    </ul>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /about/new" do
    request = """
    GET /bears/new HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 271\r
    \r
    🎉🎉🎉🎉🎉<form action="/bears" method="POST">
    <p>
      Name:<br/>
      <input type="text" name="name">
    </p>
    <p>
      Type:<br/>
      <input type="text" name="type">
    </p>
    <p>
      <input type="submit" value="Create Bear">
    </p>
    </form>🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 33\r
           \r
           Created a Brown bear named Baloo!
           """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 645\r
    \r
    🎉🎉🎉🎉🎉[{"type":"Brown","name":"Teddy","id":1,"hibernating":true},
     {"type":"Black","name":"Smokey","id":2,"hibernating":false},
     {"type":"Brown","name":"Paddington","id":3,"hibernating":false},
     {"type":"Grizzly","name":"Scarface","id":4,"hibernating":true},
     {"type":"Polar","name":"Snow","id":5,"hibernating":false},
     {"type":"Grizzly","name":"Brutus","id":6,"hibernating":false},
     {"type":"Black","name":"Rosie","id":7,"hibernating":true},
     {"type":"Panda","name":"Roscoe","id":8,"hibernating":false},
     {"type":"Polar","name":"Iceman","id":9,"hibernating":true},
     {"type":"Grizzly","name":"Kenai","id":10,"hibernating":false}]🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 35\r
           \r
           Created a Polar bear named Breezly!
           """
  end

  @tag :skip
  test "GET /snapshots" do
    request = """
    GET /snapshots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 342\r
    \r
    🎉🎉🎉🎉🎉<h1>Sensors</h1><h2>Snapshots</h2><ul><li><imgsrc=\"cam-1-snapshot.jpg\"alt=\"snapshot\"></li><li><imgsrc=\"cam-2-snapshot.jpg\"alt=\"snapshot\"></li><li><imgsrc=\"cam-3-snapshot.jpg\"alt=\"snapshot\"></li></ul><h2>WhereIsBigfoot?</h2>%{lat:\"29.0469N\",lng:\"98.8667W\"}🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /sensors" do
    request = """
    GET /sensors HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 77\r
    \r
    🎉🎉🎉🎉🎉%{lat:\"29.0469N\",lng:\"98.8667W\"}🎉🎉🎉🎉🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
