--  Author: Dylan McDougall, dmcdougall2019@my.fit.edu
--  Author: Jordan Arevalos, Jarevalos2017@my.fit.edu
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
         Buffer     : String           := Get_Line; -- read in first line
         I          : Integer          := Buffer'First;
         R, C, B    : Integer; -- Rows, Columns, Binary Columns
         Background : constant Integer := -1;
      begin
         -- PARSE INPUT
         -- Split the two numbers in the first line by a space char
         while Buffer (I) /= ' ' loop
            I := I + 1;
         end loop;
         R := Integer'Value (Buffer (Buffer'First .. I - 1)); -- parse rows
         C := Integer'Value (Buffer (I + 1 .. Buffer'Last)); -- parse cols
         B := 4 * C; -- Cols after converting from ascii hex to binary

         -- Exit if end of input
         if R = 0 and C = 0 then
            exit;
         end if;

         -- Read in the image into Bitmap
         declare
            Bitmap : Array2D (1 .. R, 1 .. B); -- declare RxB bitmap
            Buffer : String (1 .. C);
            X      : Integer;
            ID     : Integer;
         begin
            -- Read scan lines into Bitmap
            for I in 1 .. R loop
               Buffer := Get_Line;
               for J in 1 .. C loop
                  -- convert this character into binary
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
            end loop; -- done reading image

            -- DONE PARSING INPUT

            -- PROCESS DATA
            -- Fill the background of the image with value Background
            -- Go along the edges of the Bitmap and fill all zero values with Background.
            for J in 1 .. B loop
               if Bitmap (1, J) = 0 then
                  Do_Flood_Fill (Bitmap, 1, J, Background);
               end if;
               if Bitmap (R, J) = 0 then
                  Do_Flood_Fill (Bitmap, R, J, Background);
               end if;
            end loop;
            for I in 1 .. R loop
               if Bitmap (I, 1) = 0 then
                  Do_Flood_Fill (Bitmap, I, 1, Background);
               end if;
               if Bitmap (I, B) = 0 then
                  Do_Flood_Fill (Bitmap, I, B, Background);
               end if;
            end loop;

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
                  Glyphs     : array (10 .. ID) of Integer;
                  GlyphNames : array (10 .. ID) of String (1 .. 1);
                  Least      : Integer;
                  Tmp        : String (1 .. 1);
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

                  -- Set GlyphNames
                  for I in Glyphs'Range loop
                     case (Glyphs (I)) is
                        when 0 => GlyphNames (I) := "W";
                        when 1 => GlyphNames (I) := "A";
                        when 2 => GlyphNames (I) := "K";
                        when 3 => GlyphNames (I) := "J";
                        when 4 => GlyphNames (I) := "S";
                        when 5 => GlyphNames (I) := "D";
                        when others => raise Ex with "Unknown Hieroglyph";
                     end case;
                  end loop;
                  Put_Line ("");

                  -- Sort GlyphNames (Selection Sort)
                  for I in GlyphNames'Range loop
                     Least := I;
                     for J in (I + 1) .. GlyphNames'Last loop
                        if GlyphNames (J) < GlyphNames (Least) then
                           Least := J;
                        end if;
                     end loop;

                     Tmp := GlyphNames (I);
                     GlyphNames (I) := GlyphNames (Least);
                     GlyphNames (Least) := Tmp;
                  end loop; -- End Sort

                  -- Print out GlyphNames
                  for I in GlyphNames'Range loop
                     Put (GlyphNames (I));
                  end loop;
                  Put_Line("");

               end;
            end if;

         end;
      end;
   end loop;
end Main;
