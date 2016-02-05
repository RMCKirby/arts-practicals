with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
procedure Practical5 is

  Releaser : constant Integer := 3;

  protected Controller is
    entry WaitOnBarrier(client : Integer);
  private
    entry WaitOnRelease(client : Integer);
    OpenBarrier : Boolean := false;
  end Controller;

  protected body Controller is
    entry WaitOnBarrier(client : Integer) when true is
    begin
      if client = Releaser then
        OpenBarrier := true;
      elsif client /= Releaser then
        requeue WaitOnRelease with abort;
      end if;
    end WaitOnBarrier;

    entry WaitOnRelease(client : Integer) when OpenBarrier is
    begin
      Put_Line("Client " & Integer'image(client) & " being released from barrier");
      if WaitOnRelease'Count = 0 then
        OpenBarrier := false;
      end if;
    end WaitOnRelease;
  end Controller;

  task type Client(Id : Integer);

  task body Client is
  begin
    Put_Line("Client " & Integer'image(Id) & " waiting on barrier");
    select
      Controller.WaitOnBarrier(Id);
      Put_Line("Client " & Integer'image(Id) & " executing after barrier");
    or delay 0.3;
      Put_Line("Client " & Integer'image(Id) & " missed release from barrier");
    end select;
  end Client;

  type Client_P is access Client;
  type Client_Array is array(1..6) of Client_P;

  clients : Client_Array;

  procedure Free_Client is new Ada.Unchecked_Deallocation (Object => Client, Name => Client_P);

begin
  for i in Integer range 1..6 loop
    clients := (others => new Client(i));
  end loop;

  delay 1.0;

  for i in clients'Range loop
    Free_Client(clients(i));
  end loop;
end Practical5;
