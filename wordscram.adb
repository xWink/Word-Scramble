with Ada.Text_IO; use Ada.Text_IO;
with Ada.Directories, Ada.Direct_IO;
with Ada.strings.unbounded; use Ada.strings.unbounded;
with Ada.strings.unbounded.Text_IO; use Ada.strings.unbounded.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Wordscram is
    file_name: Unbounded_string;
    word_count : Integer;

    function getFilename return Unbounded_string is
    fp : File_Type;
    valid : Boolean;
    begin
        loop
            begin
                valid := true;
                put("Filename: "); --prompt user for input
                get_line(file_name);
                open(fp, in_file, To_String(file_name)); --try to open file
                if is_open(fp) then
                    close(fp);
                end if;
                exception
                    when name_error | status_error | use_error | mode_error =>
                        valid := false; --set valid to false if file can't open
            end;
            exit when valid; --get input until valid file given
        end loop;
        return file_name;
    end getFilename;

    function isWord(word : String) return Boolean is
    begin
        for i in 1..word'length loop --go through each char in string
            if not is_letter(word(i)) then --if string has non-letter
                return false; --then it is not a word
            end if;
        end loop;
        return true; --else it is a word
    end isWord;

    function randomInt(a,b : Integer) return Integer is
    gen : Generator;
    int : Integer;
    begin
        reset(gen); --init random num generator
        int := Integer(Float(a) + (Float(b - a) * Random(gen))); --get random num in range a-b
        return int;
    end randomInt;

    function scrambleWord(word : String; length : Integer) return String is
    is_scrambled : Array(1..length) of Boolean;
    output : String(1..length);
    random : Integer;
    begin
        if length <= 3 then
            for i in 1..length loop
                output(i) := word(i);
            end loop;
            return output;
        end if;

        is_scrambled := (1..length => false); --nothing scrambled yet
        output(1) := word(word'first); --set first letter
        output(length) := word(length); --set last letter

        for i in 2..length-1 loop --scramble the letters
            loop
                random := randomInt(2, length-1);
                exit when is_scrambled(random) = false;
            end loop;
            output(random) := word(i);
            is_scrambled(random) := true;
        end loop;

        return output;
    end scrambleWord;

    function processText(file_name : String) return Integer is
    word : Unbounded_String;
    num_words, next_index : Integer;
    file_size : constant Natural := Natural(Ada.Directories.Size (file_name));
    subtype File_String    is String (1 .. file_size);
    package File_String_IO is new Ada.Direct_IO (File_String);
    contents : File_String;
    fp : File_String_IO.file_type;
    begin
        
        File_String_IO.open(fp, File_String_IO.In_File, file_name); --open file
        File_String_IO.read(fp, contents); --read file into contents string
        File_String_IO.close(fp); --close file
        
        num_words := 0;
        next_index := 0;
        for i in 1..contents'length loop --process every word
            if i >= next_index then
                for j in i..contents'length loop
                    append(word, contents(j)); --create substring
                    if not is_letter(contents(j)) then --find end of substring
                        if length(word) > 1 and isWord(slice(word, 1, length(word)-1)) then --print scrambled words
                            num_words := num_words + 1;
                            put(scrambleWord(to_string(word), j - i));
                            put(contents(j));
                        else
                            put(to_string(word)); --print nonscrambled nonwords
                        end if;
                        next_index := j+1;
                        exit;
                    end if;
                end loop;
                delete(word, 1, length(word)); --reset substring
            end if;
        end loop;

        return num_words;
    end processText;

    begin
    file_name := getFilename; --get file
    new_line;
    word_count := processText(to_string(file_name)); --process text and get wordcount
    new_line;
    put("Words:" & Integer'Image(word_count)); --print number of words
end Wordscram;
