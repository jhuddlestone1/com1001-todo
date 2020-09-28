PRIORITY_MIN = 0
PRIORITY_MAX = 9
$priority = 3
$todo_list = []

def setup
  puts 'Todo List v0.02'
end

def finished()
  puts "Bye..."
end

# The following is necessary because .to_i returns 0 for ANY STRING (seriously?!),
# and because the Integer() wrapper throws ArgumentError if string not numeric...
def parse_int(str)
  int = str.to_i
  return int.to_s == str ? int : nil
end

def check_line_exists(line)
  return 0 <= line && line < $todo_list.length
end

def check_priority_bounds(priority)
  return PRIORITY_MIN <= priority && priority <= PRIORITY_MAX
end

def set_priority(str)
  if str == ''
    puts "  Priority is currently #{$priority}"
  else
    priority = parse_int(str)
    if priority && check_priority_bounds(priority)
      $priority = priority
    else
      puts "  :( Priority must be #{PRIORITY_MIN} to #{PRIORITY_MAX}"
    end
  end
end

def inc_priority(line)
  line = parse_int(line)
  if line && check_line_exists(line)
    if $todo_list[line][0] < PRIORITY_MAX
      $todo_list[line][0] += 1
    else
      puts "  :| Line #{line} is already at maximum priority!"
      puts "  #{line} (#{$todo_list[line][0]}) #{$todo_list[line][1]}"
    end
  else
    puts "  :( No such line!"
  end
end

def delete_todo(line)
  line = parse_int(line)
  if line && check_line_exists(line)
    $todo_list.slice!(line)
  else
    puts "  :( No such line!"
  end
end

def add_todo(todo)
  if todo == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  else
    $todo_list.push [$priority, todo]
  end
end 

def list_todo(str)
  result = false
  priority = parse_int(str)
  # Reverse sort array
  $todo_list.sort! do |a, b|
    b[0] <=> a[0]
  end
  $todo_list.each.with_index do |todo, index|
    if priority
      # Priority matching
      if todo[0] >= priority
        result = true
        puts "  #{index} (#{todo[0]}) #{todo[1]}"
      end
    else
      # String matching
      if todo[1].include?(str)
        result = true
        puts "  #{index} (#{todo[0]}) #{todo[1]}"
      end
    end
  end
  if !result
    puts "  :| No matching Todos"
  end
end

def tidy_todo()
  # Alpha sort
  $todo_list.sort! do |a, b|
    a[1] <=> b[1]
  end
  # Delete whichever of neighbouring identical tasks has lowest priority
  i = 0
  while i < $todo_list.length - 1
    if $todo_list[i][1] == $todo_list[i+1][1]
      $todo_list.slice!($todo_list[i][0] < $todo_list[i+1][0] ? i : i+1)
    else
      i += 1
    end
  end
  # The array will have likely changed, so reprint list for convenience
  list_todo("")
end

def parse_command(line)
  letter = line[0]
  stripped = line[1..-1].strip
  case letter
  when 'A'
    add_todo(stripped)
  when 'D'
    delete_todo(stripped)
  when 'L'
    list_todo(stripped)
  when 'T'
    tidy_todo()
  when 'P'
    set_priority(stripped)
  when '+'
    inc_priority(stripped)
  when '='
    list_todo(stripped)
  else
    puts 'Commands: Q-uit P-riority A-dd D-elete T-idy L-ist'
    puts '          +(increment line priority) =(list by priority)'
  end
end

# The main command loop
def main_loop()
  setup()
  finished = false
  while !finished
    print ":) "
    line = gets.chomp
    if line == 'Q'
      finished = true
    else
      parse_command(line)
    end
  end
  exit
end
  
main_loop()