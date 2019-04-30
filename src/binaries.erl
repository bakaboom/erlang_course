-module(binaries).
-export([create_packet/1, handle_packet/1]).

create_packet(Msg) ->
    Id = 118,
    HType1 = 2#10,
    HType2 = 2#01,
    Mode = <<"ACT">>,
    BinMsg = list_to_binary(Msg),
    % Value:Size/Type:Unit
    <<Id,HType1:2,HType2:1,Mode/binary,BinMsg/binary>>.

handle_packet(Packet) ->
    <<Id, H1:2, 1:1, Mode:24/bitstring, RestMsg/binary>> = Packet,
    {Id, H1, 1, Mode, binary_to_list(RestMsg)}.
