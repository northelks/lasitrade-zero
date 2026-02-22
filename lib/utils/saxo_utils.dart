import 'dart:convert';
import 'dart:typed_data';

// import 'package:lasitrade/logger.dart';

List<Map<String, dynamic>> fnSaxoParseMessageFrame(ByteBuffer data) {
  final message = ByteData.view(data);
  final parsedMessages = <Map<String, dynamic>>[];
  var index = 0;
  late int messageId;
  late int referenceIdSize;
  late Uint8List referenceIdBuffer;
  late String referenceId;
  late int payloadFormat;
  late int payloadSize;
  late Uint8List payloadBuffer;
  dynamic payload;
  final utf8Decoder = Utf8Decoder();

  while (index < data.lengthInBytes) {
    /* Message identifier (8 bytes)
     * 64-bit little-endian unsigned integer identifying the message.
     * The message identifier is used by clients when reconnecting. It may not be a sequence number and no interpretation
     * of its meaning should be attempted at the client.
     */
    messageId = message.getInt64(index, Endian.little);
    index += 8;

    /* Version number (2 bytes)
     * Ignored in this example. Get it using 'messageEnvelopeVersion = message.getInt16(index)'.
     */
    index += 2;

    /* Reference id size 'Srefid' (1 byte)
     * The number of characters/bytes in the reference id that follows.
     */
    referenceIdSize = message.getInt8(index);
    index += 1;

    /* Reference id (Srefid bytes)
     * ASCII encoded reference id for identifying the subscription associated with the message.
     * The reference id identifies the source subscription, or type of control message (like '_heartbeat').
     */
    referenceIdBuffer = data.asUint8List(index, referenceIdSize);
    referenceId = String.fromCharCodes(referenceIdBuffer);
    index += referenceIdSize;

    /* Payload format (1 byte)
     * 8-bit unsigned integer identifying the format of the message payload. Currently the following formats are defined:
     * 0: The payload is a UTF-8 encoded text string containing JSON.
     * 1: The payload is a binary protobuffer message.
     * The format is selected when the client sets up a streaming subscription so the streaming connection may deliver a mixture of message format.
     * Control messages such as subscription resets are not bound to a specific subscription and are always sent in JSON format.
     */
    payloadFormat = message.getUint8(index);
    index += 1;

    /* Payload size 'Spayload' (4 bytes)
     * 32-bit unsigned integer indicating the size of the message payload.
     */
    payloadSize = message.getUint32(index, Endian.little);
    index += 4;

    /* Payload (Spayload bytes)
     * Binary message payload with the size indicated by the payload size field.
     * The interpretation of the payload depends on the message format field.
     */
    payloadBuffer = data.asUint8List(index, payloadSize);
    payload = null;
    switch (payloadFormat) {
      case 0:
        // JSON
        try {
          payload = jsonDecode(utf8Decoder.convert(payloadBuffer));
        } catch (error) {
          // logger.e(error);
        }
        break;
      case 1:
        // ProtoBuf
        // logger.w("Protobuf is not covered by this sample");
        break;
      default:
      // logger.w("Unsupported payloadFormat: $payloadFormat");
    }

    if (payload != null) {
      parsedMessages.add({
        "messageId": messageId,
        "referenceId": referenceId,
        "payload": payload,
      });
    }

    index += payloadSize;
  }
  return parsedMessages;
}
