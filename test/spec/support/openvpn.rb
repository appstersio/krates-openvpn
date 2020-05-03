# Waits for connection to be established
def wait_to_connect(conn)
    begin
        state = send_cmd 'state all', conn
        puts state
        connected = state.any? {|s| s.match? 'CONNECTED,SUCCESS'}
    end until connected
    connected
end

# Wait for init sequence completion
def init_seq_completed(conn)
    begin
        logs = send_cmd 'log all', conn
        seq_ready = logs.any? {|s| s.match? 'Initialization Sequence Completed'}
    end until seq_ready
    seq_ready
end

# Multi-attempt establish connection helper
def connect_to(host, port, attempts = 30)
    while attempts > 0 do
        begin
            return Net::Telnet::new('Host' => host, 'Port' => port)
        rescue => e
            attempts -= 1
            sleep rand(2...5.0)
        end
    end
end

# Sends a command using specified connection
def send_cmd(cmd, conn)
    out = conn.cmd('String' => cmd, 'Match' => /(SUCCESS:.*\n|ERROR:.*\n|END.*\n)/)
    out.lines
end