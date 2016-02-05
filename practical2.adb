with Ada.Text_IO; use Ada.Text_IO;
procedure Practical2 is
  task PrintNumbers;
  task PrintLetters;

  task body PrintNumbers is
  begin
    for i in Integer range 1..100 loop
      Put_Line(integer'image(i));
    end loop;
  end PrintNumbers;

  task body PrintLetters is
  begin
    for c in Character range 'a'..'z' loop
      Put_Line(character'image(c));
    end loop;
    for c in Character range 'A'..'Z' loop
      Put_Line(character'image(c));
    end loop;
  end PrintLetters;

begin
  null;
end Practical2;
