--  Author: Dylan McDougall, dmcdougall2019@my.fit.edu
--  Course: CSE 4250, Spring 2022
--  Project: Proj2, Egyptian Hieroglyphs
--  Language Implementation: GNAT 20210519-103

with Ada.Text_IO; use Ada.Text_IO;
with Flood_Fill;  use Flood_Fill;

procedure Main is
   Ex : Exception;
begin
   loop
      declare
         Buffer     : String           := Get_Line;
         I          : Integer          := Buffer'First;
         R, C, B    : Integer;
         Background : constant Integer := -1;
      begin
         -- Read Rows, Cols of input
         while Buffer (I) /= ' ' loop
            I := I + 1;
         end loop;
         R := Integer'Value (Buffer (Buffer'First .. I - 1));
         C := Integer'Value (Buffer (I + 1 .. Buffer'Last));
         B := 4 * C; -- Cols after converte from hex to binary

         -- Exit if end of input
         if R = 0 and C = 0 then
            exit;
         end if;

         declare
            Bitmap : Array2D (1 .. R, 1 .. B);
            Buffer : String (1 .. C);
            X      : Integer;
            ID     : Integer;
         begin
            -- Read scan lines into Bitmap
            for I in 1 .. R loop
               Buffer := Get_Line;
               for J in 1 .. C loop
                  case (Buffer (J)) is
                     when '0' => X := 0;
                     when '1' => X := 1;
                     when '2' => X := 2;
                     when '3' => X := 3;
                     when '4' => X := 4;
                     when '5' => X := 5;
                     when '6' => X := 6;
                     when '7' => X := 7;
                     when '8' => X := 8;
                     when '9' => X := 9;
                     when 'a' | 'A' => X := 10;
                     when 'b' | 'B' => X := 11;
                     when 'c' | 'C' => X := 12;
                     when 'd' | 'D' => X := 13;
                     when 'e' | 'E' => X := 14;
                     when 'f' | 'F' => X := 15;
                     when others => raise Ex with "Invalid Character";
                  end case;
                  for K in 0 .. 3 loop
                     Bitmap (I, 4 * J - K) := X mod 2;
                     X                     := X / 2;
                  end loop;
               end loop;
            end loop;

            -- Fill Background with value Background
            Do_Flood_Fill (Bitmap, 1, 1, Background);

            -- Assign each hieroglyph an ID of 10, 11, 12, 13, ...
            ID := 9;
            for I in Bitmap'Range (1) loop
               for J in Bitmap'Range (2) loop
                  if Bitmap (I, J) = 1 then
                     ID := ID + 1;
                     Do_Flood_Fill (Bitmap, I, J, ID);
                  end if;
               end loop;
            end loop;

            if not (ID > 9) then -- if there are no hieroglyphs
               Put_Line ("");
            else
               declare
                  -- Use this to count how many holes a given hieroglyph has
                  Glyphs : array (10 .. ID) of Integer;
               begin
                  -- Initialize Glyphs with 0's.
                  for I in Glyphs'Range loop
                     Glyphs (I) := 0;
                  end loop;

                  -- If you find a 0 (a hole), see the heiroglyph
                  -- it's a part of, count it, and fill it.
                  for I in Bitmap'Range (1) loop
                     for J in Bitmap'Range (2) loop
                        if Bitmap (I, J) = 0 then
                           ID          := Bitmap (I, J - 1);
                           Glyphs (ID) := Glyphs (ID) + 1;
                           Do_Flood_Fill (Bitmap, I, J, ID);
                        end if;
                     end loop;
                  end loop;

                  -- Print out the results
                  for I in Glyphs'Range loop
                     case (Glyphs (I)) is
                        when 0 => Put ("W");
                        when 1 => Put ("A");
                        when 2 => Put ("K");
                        when 3 => Put ("J");
                        when 4 => Put ("S");
                        when 5 => Put ("D");
                        when others => raise Ex with "Unknown Hieroglyph";
                     end case;
                  end loop;
                  Put_Line ("");

               end;
            end if;

         end;
      end;
   end loop;
end Main;
