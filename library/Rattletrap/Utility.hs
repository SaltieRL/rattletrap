module Rattletrap.Utility where

import qualified Data.Binary.Bits.Get as BinaryBit
import qualified Data.Bits as Bits
import qualified Data.ByteString.Lazy as ByteString
import qualified Data.Word as Word

getRemainingBits :: BinaryBit.BitGet [Bool]
getRemainingBits = do
  isEmpty <- BinaryBit.isEmpty
  if isEmpty
    then pure []
    else do
      bit <- BinaryBit.getBool
      bits <- getRemainingBits
      pure (bit : bits)

padBytes
  :: Integral a
  => a -> ByteString.ByteString -> ByteString.ByteString
padBytes size bytes =
  ByteString.concat
    [ bytes
    , ByteString.replicate (fromIntegral size - ByteString.length bytes) 0x00
    ]

reverseByte :: Word.Word8 -> Word.Word8
reverseByte byte =
  Bits.shiftR (byte Bits..&. Bits.bit 7) 7 +
  Bits.shiftR (byte Bits..&. Bits.bit 6) 5 +
  Bits.shiftR (byte Bits..&. Bits.bit 5) 3 +
  Bits.shiftR (byte Bits..&. Bits.bit 4) 1 +
  Bits.shiftL (byte Bits..&. Bits.bit 3) 1 +
  Bits.shiftL (byte Bits..&. Bits.bit 2) 3 +
  Bits.shiftL (byte Bits..&. Bits.bit 1) 5 +
  Bits.shiftL (byte Bits..&. Bits.bit 0) 7

reverseBytes :: ByteString.ByteString -> ByteString.ByteString
reverseBytes bytes = ByteString.map reverseByte bytes
