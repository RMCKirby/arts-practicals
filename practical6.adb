with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
procedure Practical6 is

  type Client_Id is new Integer range 1..6;
  type Client_Arrived is array(Client_Id) of Boolean;

  protected Controller is
    entry WaitOnBarrier(client : Client_Id);
  private
    entry WaitOnRelease(Client_Id) (client : Client_Id);
    Arrived_Clients : Client_Arrived := (others => False);
    Arrived_Count : Integer := 0;
  end Controller;

  protected body Controller is
    entry WaitOnBarrier(client : Integer) when True is
    begin
      Arrived_Count := Arrived_Count + 1;
      if Arrived_Count /= Client_Id'Length then
        requeue WaitOnRelease(client) with abort;
      end if;
    end WaitOnBarrier;
    entry WaitOnRelease(for C in Client_Id) (client : Integer) when Arrived_Clients(C) is
    begin
      Put_Line("Task " & Client_Id'Image(client) & " being released from barrier...");
      if Client_Id /= Client_Id'Last then
        Arrived_Clients(Client_Id) := true;
      end if;
    end WaitOnRelease;
  end Controller;

  subtype Delay_Time is Integer range 1..10;
  package Random_Integer is new Ada.Numerics.Discrete_Random(Delay_Time);

  task type Client(Id : Client_Id);

  task body Client is
    Gen : Random_Integer.generator;
    Random_Int : Integer;
  begin
      Random_Integer.Reset(Gen, Id);
      Random_Int := Random_Integer.Random(Gen);
      Put_Line("Task " & Client_Id'Image(Number) &" Random delay is " & Integer'Image(Random_Int));
      delay Random_Int * 1.0;
      select
        Controller.WaitOnBarrier(Id);
        Put_Line("Client " & Client_Id'image(Id) & " executing after barrier");
      or delay 0.3;
        Put_Line("Client " & Client_Id'image(Id) & " missed release from barrier");
      end select;
  end Client;

  type Client_P is access Client;
  type Client_Array is array(1..6) of Client_P;
  clients : Client_Array;

  procedure Free_Client is new Ada.Unchecked_Deallocation (Object => Client, Name => Client_P);

begin
  for i in Client_Id'Range loop
    clients := (others => new Client(i));
  end loop;

  delay 0.5;

  for i in clients'Range loop
    Free_Client(clients(i));
  end loop;
end Practical6;
