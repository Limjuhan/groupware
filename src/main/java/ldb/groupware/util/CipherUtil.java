package ldb.groupware.util;

import org.springframework.stereotype.Component;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

@Component
public class CipherUtil {

    private static final byte[] iv = new byte[] {
            (byte) 0x8E, 0x12, 0x39, (byte) 0x90,
            0x07, 0x72, 0x6F, (byte) 0x5A,
            (byte) 0x8E, 0x12, 0x39, (byte) 0x90,
            0x07, 0x72, 0x6F, (byte) 0x5A
    };

    public byte[] generateKey(String memId) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(memId.getBytes());
            return Arrays.copyOf(hash, 32);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to generate key", e);
        }
    }

    public String encrypt(String plain, String memId) {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            SecretKeySpec key = new SecretKeySpec(generateKey(memId), "AES");
            IvParameterSpec paramSpec = new IvParameterSpec(iv);
            cipher.init(Cipher.ENCRYPT_MODE, key, paramSpec);
            byte[] cipherMsg = cipher.doFinal(plain.getBytes());
            return byteToHex(cipherMsg).trim();
        } catch (Exception e) {
            throw new RuntimeException("Encryption failed", e);
        }
    }

    public String decrypt(String cipherMsg, String memId) {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            SecretKeySpec key = new SecretKeySpec(generateKey(memId), "AES");
            IvParameterSpec paramSpec = new IvParameterSpec(iv);
            cipher.init(Cipher.DECRYPT_MODE, key, paramSpec);
            byte[] plainMsg = cipher.doFinal(hexToByte(cipherMsg.trim()));
            return new String(plainMsg).trim();
        } catch (Exception e) {
            throw new RuntimeException("Decryption failed", e);
        }
    }

    private String byteToHex(byte[] cipherMsg) {
        if (cipherMsg == null) {
            return null;
        }
        StringBuilder str = new StringBuilder();
        for (byte b : cipherMsg) {
            str.append(String.format("%02x", b));
        }
        return str.toString();
    }

    private byte[] hexToByte(String str) {
        if (str == null || str.length() < 2) {
            return null;
        }
        int len = str.length() / 2;
        byte[] buf = new byte[len];
        for (int i = 0; i < len; i++) {
            buf[i] = (byte) Integer.parseInt(str.substring(i * 2, i * 2 + 2), 16);
        }
        return buf;
    }
}