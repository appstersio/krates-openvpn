describe 'client connectivity' do
    before(:all) do
        # Wait for the server to be online
        # binding.pry
        # Query client configuration
        run! 'docker exec krates-ovpn ovpn_getclient KONTENA_VPN_CLIENT', output: "config.ovpn"
        # Launch a new client instance
        k = run! 'openvpn --config config.ovpn --daemon --management 127.0.0.1 9999'
    end

    after(:all) do
        # Teardown an daemon instance of the client
        k = run! "pkill -ex openvpn"
        puts k.out
    end

    it 'should be able to connect' do
        # Opens a connection with the client
        cn = connect_to '127.0.0.1', 9999
        connected = wait_to_connect cn
        # Close socket
        cn.close
        # Assert
        expect(connected).to be_truthy
    end
end