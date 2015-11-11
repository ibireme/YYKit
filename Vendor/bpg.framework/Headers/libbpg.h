/*
 * BPG decoder
 * 
 * Copyright (c) 2014 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#ifndef _LIBBPG_H
#define _LIBBPG_H

typedef struct BPGDecoderContext BPGDecoderContext;

typedef enum {
    BPG_FORMAT_GRAY,
    BPG_FORMAT_420, /* chroma at offset (0.5, 0.5) (JPEG) */
    BPG_FORMAT_422, /* chroma at offset (0.5, 0) (JPEG) */
    BPG_FORMAT_444,
    BPG_FORMAT_420_VIDEO, /* chroma at offset (0, 0.5) (MPEG2) */
    BPG_FORMAT_422_VIDEO, /* chroma at offset (0, 0) (MPEG2) */
} BPGImageFormatEnum;

typedef enum {
    BPG_CS_YCbCr,
    BPG_CS_RGB,
    BPG_CS_YCgCo,
    BPG_CS_YCbCr_BT709,
    BPG_CS_YCbCr_BT2020,

    BPG_CS_COUNT,
} BPGColorSpaceEnum;

typedef struct {
    uint32_t width;
    uint32_t height;
    uint8_t format; /* see BPGImageFormatEnum */
    uint8_t has_alpha; /* TRUE if an alpha plane is present */
    uint8_t color_space; /* see BPGColorSpaceEnum */
    uint8_t bit_depth;
    uint8_t premultiplied_alpha; /* TRUE if the color is alpha premultiplied */
    uint8_t has_w_plane; /* TRUE if a W plane is present (for CMYK encoding) */
    uint8_t limited_range; /* TRUE if limited range for the color */
    uint8_t has_animation; /* TRUE if the image contains animations */
    uint16_t loop_count; /* animations: number of loop, 0 = infinity */
} BPGImageInfo;

typedef enum {
    BPG_EXTENSION_TAG_EXIF = 1,
    BPG_EXTENSION_TAG_ICCP = 2,
    BPG_EXTENSION_TAG_XMP = 3,
    BPG_EXTENSION_TAG_THUMBNAIL = 4,
    BPG_EXTENSION_TAG_ANIM_CONTROL = 5,
} BPGExtensionTagEnum;

typedef struct BPGExtensionData {
    BPGExtensionTagEnum tag;
    uint32_t buf_len;
    uint8_t *buf;
    struct BPGExtensionData *next;
} BPGExtensionData;

typedef enum {
    BPG_OUTPUT_FORMAT_RGB24,
    BPG_OUTPUT_FORMAT_RGBA32, /* not premultiplied alpha */
    BPG_OUTPUT_FORMAT_RGB48,
    BPG_OUTPUT_FORMAT_RGBA64, /* not premultiplied alpha */
    BPG_OUTPUT_FORMAT_CMYK32,
    BPG_OUTPUT_FORMAT_CMYK64,
} BPGDecoderOutputFormat;

#define BPG_DECODER_INFO_BUF_SIZE 16

BPGDecoderContext *bpg_decoder_open(void);

/* If enable is true, extension data are kept during the image
   decoding and can be accessed after bpg_decoder_decode() with
   bpg_decoder_get_extension(). By default, the extension data are
   discarded. */
void bpg_decoder_keep_extension_data(BPGDecoderContext *s, int enable);

/* return 0 if 0K, < 0 if error */
int bpg_decoder_decode(BPGDecoderContext *s, const uint8_t *buf, int buf_len);

/* Return the first element of the extension data list */
BPGExtensionData *bpg_decoder_get_extension_data(BPGDecoderContext *s);

/* return 0 if 0K, < 0 if error */
int bpg_decoder_get_info(BPGDecoderContext *s, BPGImageInfo *p);

/* return 0 if 0K, < 0 if error */
int bpg_decoder_start(BPGDecoderContext *s, BPGDecoderOutputFormat out_fmt);

/* return the frame delay for animations as a fraction (*pnum) / (*pden)
   in seconds. In case there is no animation, 0 / 1 is returned. */
void bpg_decoder_get_frame_duration(BPGDecoderContext *s, int *pnum, int *pden);

/* return 0 if 0K, < 0 if error */
int bpg_decoder_get_line(BPGDecoderContext *s, void *buf);

void bpg_decoder_close(BPGDecoderContext *s);

/* only useful for low level access to the image data */
uint8_t *bpg_decoder_get_data(BPGDecoderContext *s, int *pline_size, int plane);

/* Get information from the start of the image data in 'buf' (at least
   min(BPG_DECODER_INFO_BUF_SIZE, file_size) bytes must be given).

   If pfirst_md != NULL, the extension data are also parsed and the
   first element of the list is returned in *pfirst_md. The list must
   be freed with bpg_decoder_free_extension_data().

   BPGImageInfo.loop_count is only set if extension data are parsed.

   Return 0 if OK, < 0 if unrecognized data. */
int bpg_decoder_get_info_from_buf(BPGImageInfo *p, 
                                  BPGExtensionData **pfirst_md,
                                  const uint8_t *buf, int buf_len);
/* Free the extension data returned by bpg_decoder_get_info_from_buf() */
void bpg_decoder_free_extension_data(BPGExtensionData *first_md);

#endif /* _LIBBPG_H */
