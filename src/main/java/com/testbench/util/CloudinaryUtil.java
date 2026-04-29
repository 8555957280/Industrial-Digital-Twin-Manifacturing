package com.testbench.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.IOException;
import java.util.Map;

public class CloudinaryUtil {

    // ── Get from: https://cloudinary.com → Dashboard → API Keys ──
    private static final String CLOUD_NAME = "deqdjw4pv";
    private static final String API_KEY    = "432414991861777";
    private static final String API_SECRET = "TCF59KbVMOJcv30-ck_w6iBT1Cc";

    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
        "cloud_name", CLOUD_NAME,
        "api_key",    API_KEY,
        "api_secret", API_SECRET
    ));

    /** Upload image file from disk */
    public static String uploadFile(File file, String folder) throws IOException {
        Map result = cloudinary.uploader().upload(file, ObjectUtils.asMap(
            "folder",        folder,
            "resource_type", "auto"
        ));
        return (String) result.get("secure_url");
    }

    /** Upload image from byte array (profile photos) */
    public static String uploadBytes(byte[] bytes, String folder) throws IOException {
        Map result = cloudinary.uploader().upload(bytes, ObjectUtils.asMap(
            "folder",        folder,
            "resource_type", "auto"
        ));
        return (String) result.get("secure_url");
    }

    /** Upload raw file like CSV, PDF (reports) */
    public static String uploadRawFile(byte[] bytes, String folder, String filename) throws IOException {
        Map result = cloudinary.uploader().upload(bytes, ObjectUtils.asMap(
            "folder",        folder,
            "resource_type", "raw",
            "public_id",     filename,
            "use_filename",  true,
            "overwrite",     true
        ));
        return (String) result.get("secure_url");
    }

    /** Delete file from Cloudinary */
    public static void deleteFile(String publicId) throws IOException {
        cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
    }
}