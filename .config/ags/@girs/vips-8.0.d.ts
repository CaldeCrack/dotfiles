/// <reference path="./gio-2.0.d.ts" />
/// <reference path="./gobject-2.0.d.ts" />
/// <reference path="./glib-2.0.d.ts" />
/// <reference path="./gmodule-2.0.d.ts" />

/**
 * Type Definitions for Gjs (https://gjs.guide/)
 *
 * These type definitions are automatically generated, do not edit them by hand.
 * If you found a bug fix it in `ts-for-gir` or create a bug report on https://github.com/gjsify/ts-for-gir
 *
 * The based EJS template file is used for the generated .d.ts file of each GIR module like Gtk-4.0, GObject-2.0, ...
 */

declare module 'gi://Vips?version=8.0' {
    // Module dependencies
    import type Gio from 'gi://Gio?version=2.0';
    import type GObject from 'gi://GObject?version=2.0';
    import type GLib from 'gi://GLib?version=2.0';
    import type GModule from 'gi://GModule?version=2.0';

    export namespace Vips {
        /**
         * Vips-8.0
         */

        /**
         * The type of access an operation has to supply. See [method`Image`.tilecache]
         * and [class`Foreign]`.
         *
         * [enum`Vips`.Access.RANDOM] means requests can come in any order.
         *
         * [enum`Vips`.Access.SEQUENTIAL] means requests will be top-to-bottom, but with some
         * amount of buffering behind the read point for small non-local accesses.
         */

        /**
         * The type of access an operation has to supply. See [method`Image`.tilecache]
         * and [class`Foreign]`.
         *
         * [enum`Vips`.Access.RANDOM] means requests can come in any order.
         *
         * [enum`Vips`.Access.SEQUENTIAL] means requests will be top-to-bottom, but with some
         * amount of buffering behind the read point for small non-local accesses.
         */
        export namespace Access {
            export const $gtype: GObject.GType<Access>;
        }

        enum Access {
            /**
             * can read anywhere
             */
            RANDOM,
            /**
             * top-to-bottom reading only, but with a small buffer
             */
            SEQUENTIAL,
            SEQUENTIAL_UNBUFFERED,
            LAST,
        }
        /**
         * See [method`Image`.join] and so on.
         *
         * Operations like [method`Image`.join] need to be told whether to align images on the
         * low or high coordinate edge, or centre.
         *
         * ::: seealso
         *     [method`Image`.join].
         */

        /**
         * See [method`Image`.join] and so on.
         *
         * Operations like [method`Image`.join] need to be told whether to align images on the
         * low or high coordinate edge, or centre.
         *
         * ::: seealso
         *     [method`Image`.join].
         */
        export namespace Align {
            export const $gtype: GObject.GType<Align>;
        }

        enum Align {
            /**
             * align low coordinate edge
             */
            LOW,
            /**
             * align centre
             */
            CENTRE,
            /**
             * align high coordinate edge
             */
            HIGH,
            LAST,
        }
        /**
         * See [method`Image`.rot] and so on.
         *
         * Fixed rotate angles.
         *
         * ::: seealso
         *     [method`Image`.rot].
         */

        /**
         * See [method`Image`.rot] and so on.
         *
         * Fixed rotate angles.
         *
         * ::: seealso
         *     [method`Image`.rot].
         */
        export namespace Angle {
            export const $gtype: GObject.GType<Angle>;
        }

        enum Angle {
            /**
             * no rotate
             */
            D0,
            /**
             * 90 degrees clockwise
             */
            D90,
            /**
             * 180 degree rotate
             */
            D180,
            /**
             * 90 degrees anti-clockwise
             */
            D270,
            LAST,
        }
        /**
         * See [method`Image`.rot45] and so on.
         *
         * Fixed rotate angles.
         *
         * ::: seealso
         *     [method`Image`.rot45].
         */

        /**
         * See [method`Image`.rot45] and so on.
         *
         * Fixed rotate angles.
         *
         * ::: seealso
         *     [method`Image`.rot45].
         */
        export namespace Angle45 {
            export const $gtype: GObject.GType<Angle45>;
        }

        enum Angle45 {
            /**
             * no rotate
             */
            D0,
            /**
             * 45 degrees clockwise
             */
            D45,
            /**
             * 90 degrees clockwise
             */
            D90,
            /**
             * 135 degrees clockwise
             */
            D135,
            /**
             * 180 degrees
             */
            D180,
            /**
             * 135 degrees anti-clockwise
             */
            D225,
            /**
             * 90 degrees anti-clockwise
             */
            D270,
            /**
             * 45 degrees anti-clockwise
             */
            D315,
            LAST,
        }
        /**
         * The format used for each band element.
         *
         * Each corresponds to a native C type for the current machine. For example,
         * [enum`Vips`.BandFormat.USHORT] is `unsigned short`.
         */

        /**
         * The format used for each band element.
         *
         * Each corresponds to a native C type for the current machine. For example,
         * [enum`Vips`.BandFormat.USHORT] is `unsigned short`.
         */
        export namespace BandFormat {
            export const $gtype: GObject.GType<BandFormat>;
        }

        enum BandFormat {
            /**
             * invalid setting
             */
            NOTSET,
            /**
             * unsigned char format
             */
            UCHAR,
            /**
             * char format
             */
            CHAR,
            /**
             * unsigned short format
             */
            USHORT,
            /**
             * short format
             */
            SHORT,
            /**
             * unsigned int format
             */
            UINT,
            /**
             * int format
             */
            INT,
            /**
             * float format
             */
            FLOAT,
            /**
             * complex (two floats) format
             */
            COMPLEX,
            /**
             * double float format
             */
            DOUBLE,
            /**
             * double complex (two double) format
             */
            DPCOMPLEX,
            LAST,
        }
        /**
         * The various Porter-Duff and PDF blend modes. See [func`Image`.composite],
         * for example.
         *
         * The Cairo docs have [a nice explanation of all the blend
         * modes](https://www.cairographics.org/operators).
         *
         * The non-separable modes are not implemented.
         */

        /**
         * The various Porter-Duff and PDF blend modes. See [func`Image`.composite],
         * for example.
         *
         * The Cairo docs have [a nice explanation of all the blend
         * modes](https://www.cairographics.org/operators).
         *
         * The non-separable modes are not implemented.
         */
        export namespace BlendMode {
            export const $gtype: GObject.GType<BlendMode>;
        }

        enum BlendMode {
            /**
             * where the second object is drawn, the first is removed
             */
            CLEAR,
            /**
             * the second object is drawn as if nothing were below
             */
            SOURCE,
            /**
             * the image shows what you would expect if you held two semi-transparent slides on top of each other
             */
            OVER,
            /**
             * the first object is removed completely, the second is only drawn where the first was
             */
            IN,
            /**
             * the second is drawn only where the first isn't
             */
            OUT,
            /**
             * this leaves the first object mostly intact, but mixes both objects in the overlapping area
             */
            ATOP,
            /**
             * leaves the first object untouched, the second is discarded completely
             */
            DEST,
            /**
             * like OVER, but swaps the arguments
             */
            DEST_OVER,
            /**
             * like IN, but swaps the arguments
             */
            DEST_IN,
            /**
             * like OUT, but swaps the arguments
             */
            DEST_OUT,
            /**
             * like ATOP, but swaps the arguments
             */
            DEST_ATOP,
            /**
             * something like a difference operator
             */
            XOR,
            /**
             * a bit like adding the two images
             */
            ADD,
            /**
             * a bit like the darker of the two
             */
            SATURATE,
            /**
             * at least as dark as the darker of the two inputs
             */
            MULTIPLY,
            /**
             * at least as light as the lighter of the inputs
             */
            SCREEN,
            /**
             * multiplies or screens colors, depending on the lightness
             */
            OVERLAY,
            /**
             * the darker of each component
             */
            DARKEN,
            /**
             * the lighter of each component
             */
            LIGHTEN,
            /**
             * brighten first by a factor second
             */
            COLOUR_DODGE,
            /**
             * darken first by a factor of second
             */
            COLOUR_BURN,
            /**
             * multiply or screen, depending on lightness
             */
            HARD_LIGHT,
            /**
             * darken or lighten, depending on lightness
             */
            SOFT_LIGHT,
            /**
             * difference of the two
             */
            DIFFERENCE,
            /**
             * somewhat like DIFFERENCE, but lower-contrast
             */
            EXCLUSION,
            LAST,
        }
        /**
         * How pixels are coded.
         *
         * Normally, pixels are uncoded and can be manipulated as you would expect.
         * However some file formats code pixels for compression, and sometimes it's
         * useful to be able to manipulate images in the coded format.
         *
         * The gaps in the numbering are historical and must be maintained. Allocate
         * new numbers from the end.
         */

        /**
         * How pixels are coded.
         *
         * Normally, pixels are uncoded and can be manipulated as you would expect.
         * However some file formats code pixels for compression, and sometimes it's
         * useful to be able to manipulate images in the coded format.
         *
         * The gaps in the numbering are historical and must be maintained. Allocate
         * new numbers from the end.
         */
        export namespace Coding {
            export const $gtype: GObject.GType<Coding>;
        }

        enum Coding {
            ERROR,
            /**
             * pixels are not coded
             */
            NONE,
            /**
             * pixels encode 3 float CIELAB values as 4 uchar
             */
            LABQ,
            /**
             * pixels encode 3 float RGB as 4 uchar (Radiance coding)
             */
            RAD,
            LAST,
        }
        /**
         * How to combine values. See [method`Image`.compass], for example.
         */

        /**
         * How to combine values. See [method`Image`.compass], for example.
         */
        export namespace Combine {
            export const $gtype: GObject.GType<Combine>;
        }

        enum Combine {
            /**
             * take the maximum of the possible values
             */
            MAX,
            /**
             * sum all the values
             */
            SUM,
            /**
             * take the minimum value
             */
            MIN,
            LAST,
        }
        /**
         * See [method`Image`.draw_image] and so on.
         *
         * Operations like [method`Image`.draw_image] need to be told how to combine images
         * from two sources.
         *
         * ::: seealso
         *     [method`Image`.join].
         */

        /**
         * See [method`Image`.draw_image] and so on.
         *
         * Operations like [method`Image`.draw_image] need to be told how to combine images
         * from two sources.
         *
         * ::: seealso
         *     [method`Image`.join].
         */
        export namespace CombineMode {
            export const $gtype: GObject.GType<CombineMode>;
        }

        enum CombineMode {
            /**
             * set pixels to the new value
             */
            SET,
            /**
             * add pixels
             */
            ADD,
            LAST,
        }
        /**
         * A direction on a compass. Used for [method`Image`.gravity], for example.
         */

        /**
         * A direction on a compass. Used for [method`Image`.gravity], for example.
         */
        export namespace CompassDirection {
            export const $gtype: GObject.GType<CompassDirection>;
        }

        enum CompassDirection {
            /**
             * centre
             */
            CENTRE,
            /**
             * north
             */
            NORTH,
            /**
             * east
             */
            EAST,
            /**
             * south
             */
            SOUTH,
            /**
             * west
             */
            WEST,
            /**
             * north-east
             */
            NORTH_EAST,
            /**
             * south-east
             */
            SOUTH_EAST,
            /**
             * south-west
             */
            SOUTH_WEST,
            /**
             * north-west
             */
            NORTH_WEST,
            LAST,
        }
        /**
         * See [method`Image`.pipelinev]. Operations can hint
         * the kind of demand geometry they prefer
         * to the VIPS image IO system.
         *
         * These demand styles are given below in order of increasing
         * specialisation.  When demanding output from a pipeline,
         * [method`Image`.generate]
         * will use the most general style requested by the operations
         * in the pipeline.
         *
         * [enum`Vips`.DemandStyle.SMALLTILE] -- This is the most general demand format.
         * Output is demanded in small (around 100x100 pel) sections. This style works
         * reasonably efficiently, even for bizarre operations like 45 degree rotate.
         *
         * [enum`Vips`.DemandStyle.FATSTRIP] -- This operation would like to output strips
         * the width of the image and as high as possible. This option is suitable
         * for area operations which do not violently transform coordinates, such
         * as [method`Image`.conv].
         *
         * [enum`Vips`.DemandStyle.THINSTRIP] -- This operation would like to output strips
         * the width of the image and a few pels high. This option is suitable for
         * point-to-point operations, such as those in the arithmetic package.
         *
         * [enum`Vips`.DemandStyle.ANY] -- This image is not being demand-read from a disc
         * file (even indirectly) so any demand style is OK. It's used for things like
         * [ctor`Image`.black] where the pixels are calculated.
         *
         * ::: seealso
         *     [method`Image`.pipelinev].
         */

        /**
         * See [method`Image`.pipelinev]. Operations can hint
         * the kind of demand geometry they prefer
         * to the VIPS image IO system.
         *
         * These demand styles are given below in order of increasing
         * specialisation.  When demanding output from a pipeline,
         * [method`Image`.generate]
         * will use the most general style requested by the operations
         * in the pipeline.
         *
         * [enum`Vips`.DemandStyle.SMALLTILE] -- This is the most general demand format.
         * Output is demanded in small (around 100x100 pel) sections. This style works
         * reasonably efficiently, even for bizarre operations like 45 degree rotate.
         *
         * [enum`Vips`.DemandStyle.FATSTRIP] -- This operation would like to output strips
         * the width of the image and as high as possible. This option is suitable
         * for area operations which do not violently transform coordinates, such
         * as [method`Image`.conv].
         *
         * [enum`Vips`.DemandStyle.THINSTRIP] -- This operation would like to output strips
         * the width of the image and a few pels high. This option is suitable for
         * point-to-point operations, such as those in the arithmetic package.
         *
         * [enum`Vips`.DemandStyle.ANY] -- This image is not being demand-read from a disc
         * file (even indirectly) so any demand style is OK. It's used for things like
         * [ctor`Image`.black] where the pixels are calculated.
         *
         * ::: seealso
         *     [method`Image`.pipelinev].
         */
        export namespace DemandStyle {
            export const $gtype: GObject.GType<DemandStyle>;
        }

        enum DemandStyle {
            ERROR,
            /**
             * demand in small (typically 128x128 pixel) tiles
             */
            SMALLTILE,
            /**
             * demand in fat (typically 16 pixel high) strips
             */
            FATSTRIP,
            /**
             * demand in thin (typically 1 pixel high) strips
             */
            THINSTRIP,
            /**
             * demand geometry does not matter
             */
            ANY,
        }
        /**
         * See [method`Image`.flip], [method`Image`.join] and so on.
         *
         * Operations like [method`Image`.flip] need to be told whether to flip left-right or
         * top-bottom.
         *
         * ::: seealso
         *     [method`Image`.flip], [method`Image`.join].
         */

        /**
         * See [method`Image`.flip], [method`Image`.join] and so on.
         *
         * Operations like [method`Image`.flip] need to be told whether to flip left-right or
         * top-bottom.
         *
         * ::: seealso
         *     [method`Image`.flip], [method`Image`.join].
         */
        export namespace Direction {
            export const $gtype: GObject.GType<Direction>;
        }

        enum Direction {
            /**
             * left-right
             */
            HORIZONTAL,
            /**
             * top-bottom
             */
            VERTICAL,
            LAST,
        }
        /**
         * See [method`Image`.embed], [method`Image`.conv], [method`Image`.affine] and so on.
         *
         * When the edges of an image are extended, you can specify
         * how you want the extension done.
         *
         * [enum`Vips`.Extend.BLACK] -- new pixels are black, ie. all bits are zero.
         *
         * [enum`Vips`.Extend.COPY] -- each new pixel takes the value of the nearest edge
         * pixel
         *
         * [enum`Vips`.Extend.REPEAT] -- the image is tiled to fill the new area
         *
         * [enum`Vips`.Extend.MIRROR] -- the image is reflected and tiled to reduce hash
         * edges
         *
         * [enum`Vips`.Extend.WHITE] -- new pixels are white, ie. all bits are set
         *
         * [enum`Vips`.Extend.BACKGROUND] -- colour set from the `background` property
         *
         * We have to specify the exact value of each enum member since we have to
         * keep these frozen for back compat with vips7.
         *
         * ::: seealso
         *     [method`Image`.embed].
         */

        /**
         * See [method`Image`.embed], [method`Image`.conv], [method`Image`.affine] and so on.
         *
         * When the edges of an image are extended, you can specify
         * how you want the extension done.
         *
         * [enum`Vips`.Extend.BLACK] -- new pixels are black, ie. all bits are zero.
         *
         * [enum`Vips`.Extend.COPY] -- each new pixel takes the value of the nearest edge
         * pixel
         *
         * [enum`Vips`.Extend.REPEAT] -- the image is tiled to fill the new area
         *
         * [enum`Vips`.Extend.MIRROR] -- the image is reflected and tiled to reduce hash
         * edges
         *
         * [enum`Vips`.Extend.WHITE] -- new pixels are white, ie. all bits are set
         *
         * [enum`Vips`.Extend.BACKGROUND] -- colour set from the `background` property
         *
         * We have to specify the exact value of each enum member since we have to
         * keep these frozen for back compat with vips7.
         *
         * ::: seealso
         *     [method`Image`.embed].
         */
        export namespace Extend {
            export const $gtype: GObject.GType<Extend>;
        }

        enum Extend {
            /**
             * extend with black (all 0) pixels
             */
            BLACK,
            /**
             * copy the image edges
             */
            COPY,
            /**
             * repeat the whole image
             */
            REPEAT,
            /**
             * mirror the whole image
             */
            MIRROR,
            /**
             * extend with white (all bits set) pixels
             */
            WHITE,
            /**
             * extend with colour from the `background` property
             */
            BACKGROUND,
            LAST,
        }
        /**
         * How sensitive loaders are to errors, from never stop (very insensitive), to
         * stop on the smallest warning (very sensitive).
         *
         * Each one implies the ones before it, so [enum`Vips`.FailOn.ERROR] implies
         * [enum`Vips`.FailOn.TRUNCATED].
         */

        /**
         * How sensitive loaders are to errors, from never stop (very insensitive), to
         * stop on the smallest warning (very sensitive).
         *
         * Each one implies the ones before it, so [enum`Vips`.FailOn.ERROR] implies
         * [enum`Vips`.FailOn.TRUNCATED].
         */
        export namespace FailOn {
            export const $gtype: GObject.GType<FailOn>;
        }

        enum FailOn {
            /**
             * never stop
             */
            NONE,
            /**
             * stop on image truncated, nothing else
             */
            TRUNCATED,
            /**
             * stop on serious error or truncation
             */
            ERROR,
            /**
             * stop on anything, even warnings
             */
            WARNING,
            LAST,
        }
        /**
         * How many pyramid layers to create.
         */

        /**
         * How many pyramid layers to create.
         */
        export namespace ForeignDzContainer {
            export const $gtype: GObject.GType<ForeignDzContainer>;
        }

        enum ForeignDzContainer {
            /**
             * write tiles to the filesystem
             */
            FS,
            /**
             * write tiles to a zip file
             */
            ZIP,
            /**
             * write to a szi file
             */
            SZI,
            LAST,
        }
        /**
         * How many pyramid layers to create.
         */

        /**
         * How many pyramid layers to create.
         */
        export namespace ForeignDzDepth {
            export const $gtype: GObject.GType<ForeignDzDepth>;
        }

        enum ForeignDzDepth {
            /**
             * create layers down to 1x1 pixel
             */
            ONEPIXEL,
            /**
             * create layers down to 1x1 tile
             */
            ONETILE,
            /**
             * only create a single layer
             */
            ONE,
            LAST,
        }
        /**
         * What directory layout and metadata standard to use.
         */

        /**
         * What directory layout and metadata standard to use.
         */
        export namespace ForeignDzLayout {
            export const $gtype: GObject.GType<ForeignDzLayout>;
        }

        enum ForeignDzLayout {
            /**
             * use DeepZoom directory layout
             */
            DZ,
            /**
             * use Zoomify directory layout
             */
            ZOOMIFY,
            /**
             * use Google maps directory layout
             */
            GOOGLE,
            /**
             * use IIIF v2 directory layout
             */
            IIIF,
            /**
             * use IIIF v3 directory layout
             */
            IIIF3,
            LAST,
        }
        /**
         * The compression format to use inside a HEIF container.
         *
         * This is assumed to use the same numbering as `heif_compression_format`.
         */

        /**
         * The compression format to use inside a HEIF container.
         *
         * This is assumed to use the same numbering as `heif_compression_format`.
         */
        export namespace ForeignHeifCompression {
            export const $gtype: GObject.GType<ForeignHeifCompression>;
        }

        enum ForeignHeifCompression {
            /**
             * x265
             */
            HEVC,
            /**
             * x264
             */
            AVC,
            /**
             * jpeg
             */
            JPEG,
            /**
             * aom
             */
            AV1,
            LAST,
        }
        /**
         * The selected encoder to use.
         * If libheif hasn't been compiled with the selected encoder,
         * we will fallback to the default encoder for the compression format.
         */

        /**
         * The selected encoder to use.
         * If libheif hasn't been compiled with the selected encoder,
         * we will fallback to the default encoder for the compression format.
         */
        export namespace ForeignHeifEncoder {
            export const $gtype: GObject.GType<ForeignHeifEncoder>;
        }

        enum ForeignHeifEncoder {
            /**
             * auto
             */
            AUTO,
            /**
             * aom
             */
            AOM,
            /**
             * RAV1E
             */
            RAV1E,
            /**
             * SVT-AV1
             */
            SVT,
            /**
             * x265
             */
            X265,
            LAST,
        }

        export namespace ForeignJpegSubsample {
            export const $gtype: GObject.GType<ForeignJpegSubsample>;
        }

        enum ForeignJpegSubsample {
            AUTO,
            ON,
            OFF,
            LAST,
        }
        /**
         * The netpbm file format to save as.
         *
         * [enum`Vips`.ForeignPpmFormat.PBM] images are single bit.
         *
         * [enum`Vips`.ForeignPpmFormat.PGM] images are 8, 16, or 32-bits, one band.
         *
         * [enum`Vips`.ForeignPpmFormat.PPM] images are 8, 16, or 32-bits, three bands.
         *
         * [enum`Vips`.ForeignPpmFormat.PFM] images are 32-bit float pixels.
         *
         * [enum`Vips`.ForeignPpmFormat.PNM] images are anymap images -- the image format
         * is used to pick the saver.
         */

        /**
         * The netpbm file format to save as.
         *
         * [enum`Vips`.ForeignPpmFormat.PBM] images are single bit.
         *
         * [enum`Vips`.ForeignPpmFormat.PGM] images are 8, 16, or 32-bits, one band.
         *
         * [enum`Vips`.ForeignPpmFormat.PPM] images are 8, 16, or 32-bits, three bands.
         *
         * [enum`Vips`.ForeignPpmFormat.PFM] images are 32-bit float pixels.
         *
         * [enum`Vips`.ForeignPpmFormat.PNM] images are anymap images -- the image format
         * is used to pick the saver.
         */
        export namespace ForeignPpmFormat {
            export const $gtype: GObject.GType<ForeignPpmFormat>;
        }

        enum ForeignPpmFormat {
            /**
             * portable bitmap
             */
            PBM,
            /**
             * portable greymap
             */
            PGM,
            /**
             * portable pixmap
             */
            PPM,
            /**
             * portable float map
             */
            PFM,
            /**
             * portable anymap
             */
            PNM,
            LAST,
        }
        /**
         * Set subsampling mode.
         */

        /**
         * Set subsampling mode.
         */
        export namespace ForeignSubsample {
            export const $gtype: GObject.GType<ForeignSubsample>;
        }

        enum ForeignSubsample {
            /**
             * prevent subsampling when quality >= 90
             */
            AUTO,
            /**
             * always perform subsampling
             */
            ON,
            /**
             * never perform subsampling
             */
            OFF,
            LAST,
        }
        /**
         * The compression types supported by the tiff writer.
         *
         * Use `Q` to set the jpeg compression level, default 75.
         *
         * Use `predictor` to set the lzw or deflate prediction, default horizontal.
         *
         * Use `lossless` to set WEBP lossless compression.
         *
         * Use `level` to set webp and zstd compression level.
         */

        /**
         * The compression types supported by the tiff writer.
         *
         * Use `Q` to set the jpeg compression level, default 75.
         *
         * Use `predictor` to set the lzw or deflate prediction, default horizontal.
         *
         * Use `lossless` to set WEBP lossless compression.
         *
         * Use `level` to set webp and zstd compression level.
         */
        export namespace ForeignTiffCompression {
            export const $gtype: GObject.GType<ForeignTiffCompression>;
        }

        enum ForeignTiffCompression {
            /**
             * no compression
             */
            NONE,
            /**
             * jpeg compression
             */
            JPEG,
            /**
             * deflate (zip) compression
             */
            DEFLATE,
            /**
             * packbits compression
             */
            PACKBITS,
            /**
             * fax4 compression
             */
            CCITTFAX4,
            /**
             * LZW compression
             */
            LZW,
            /**
             * WEBP compression
             */
            WEBP,
            /**
             * ZSTD compression
             */
            ZSTD,
            /**
             * JP2K compression
             */
            JP2K,
            LAST,
        }
        /**
         * The predictor can help deflate and lzw compression. The values are fixed by
         * the tiff library.
         */

        /**
         * The predictor can help deflate and lzw compression. The values are fixed by
         * the tiff library.
         */
        export namespace ForeignTiffPredictor {
            export const $gtype: GObject.GType<ForeignTiffPredictor>;
        }

        enum ForeignTiffPredictor {
            /**
             * no prediction
             */
            NONE,
            /**
             * horizontal differencing
             */
            HORIZONTAL,
            /**
             * float predictor
             */
            FLOAT,
            LAST,
        }
        /**
         * Use inches or centimeters as the resolution unit for a tiff file.
         */

        /**
         * Use inches or centimeters as the resolution unit for a tiff file.
         */
        export namespace ForeignTiffResunit {
            export const $gtype: GObject.GType<ForeignTiffResunit>;
        }

        enum ForeignTiffResunit {
            /**
             * use centimeters
             */
            CM,
            /**
             * use inches
             */
            INCH,
            LAST,
        }
        /**
         * Tune lossy encoder settings for different image types.
         */

        /**
         * Tune lossy encoder settings for different image types.
         */
        export namespace ForeignWebpPreset {
            export const $gtype: GObject.GType<ForeignWebpPreset>;
        }

        enum ForeignWebpPreset {
            /**
             * default preset
             */
            DEFAULT,
            /**
             * digital picture, like portrait, inner shot
             */
            PICTURE,
            /**
             * outdoor photograph, with natural lighting
             */
            PHOTO,
            /**
             * hand or line drawing, with high-contrast details
             */
            DRAWING,
            /**
             * small-sized colorful images
             */
            ICON,
            /**
             * text-like
             */
            TEXT,
            LAST,
        }

        export namespace ImageType {
            export const $gtype: GObject.GType<ImageType>;
        }

        enum ImageType {
            ERROR,
            NONE,
            SETBUF,
            SETBUF_FOREIGN,
            OPENIN,
            MMAPIN,
            MMAPINRW,
            OPENOUT,
            PARTIAL,
        }
        /**
         * The rendering intent. [enum`Vips`.Intent.ABSOLUTE] is best for
         * scientific work, [enum`Vips`.Intent.RELATIVE] is usually best for
         * accurate communication with other imaging libraries.
         */

        /**
         * The rendering intent. [enum`Vips`.Intent.ABSOLUTE] is best for
         * scientific work, [enum`Vips`.Intent.RELATIVE] is usually best for
         * accurate communication with other imaging libraries.
         */
        export namespace Intent {
            export const $gtype: GObject.GType<Intent>;
        }

        enum Intent {
            /**
             * perceptual rendering intent
             */
            PERCEPTUAL,
            /**
             * relative colorimetric rendering intent
             */
            RELATIVE,
            /**
             * saturation rendering intent
             */
            SATURATION,
            /**
             * absolute colorimetric rendering intent
             */
            ABSOLUTE,
            /**
             * the rendering intent that the profile suggests
             */
            AUTO,
            LAST,
        }
        /**
         * Pick the algorithm vips uses to decide image "interestingness". This is used
         * by [method`Image`.smartcrop], for example, to decide what parts of the image to
         * keep.
         *
         * [enum`Vips`.Interesting.NONE] and [enum`Vips`.Interesting.LOW] mean the same -- the
         * crop is positioned at the top or left. [enum`Vips`.Interesting.HIGH] positions at
         * the bottom or right.
         *
         * ::: seealso
         *     [method`Image`.smartcrop].
         */

        /**
         * Pick the algorithm vips uses to decide image "interestingness". This is used
         * by [method`Image`.smartcrop], for example, to decide what parts of the image to
         * keep.
         *
         * [enum`Vips`.Interesting.NONE] and [enum`Vips`.Interesting.LOW] mean the same -- the
         * crop is positioned at the top or left. [enum`Vips`.Interesting.HIGH] positions at
         * the bottom or right.
         *
         * ::: seealso
         *     [method`Image`.smartcrop].
         */
        export namespace Interesting {
            export const $gtype: GObject.GType<Interesting>;
        }

        enum Interesting {
            /**
             * do nothing
             */
            NONE,
            /**
             * just take the centre
             */
            CENTRE,
            /**
             * use an entropy measure
             */
            ENTROPY,
            /**
             * look for features likely to draw human attention
             */
            ATTENTION,
            /**
             * position the crop towards the low coordinate
             */
            LOW,
            /**
             * position the crop towards the high coordinate
             */
            HIGH,
            /**
             * everything is interesting
             */
            ALL,
            LAST,
        }
        /**
         * How the values in an image should be interpreted. For example, a
         * three-band float image of type [enum`Vips`.Interpretation.LAB] should have its
         * pixels interpreted as coordinates in CIE Lab space.
         *
         * RGB and sRGB are treated in the same way. Use the colourspace functions if
         * you want some other behaviour.
         *
         * The gaps in numbering are historical and must be maintained. Allocate
         * new numbers from the end.
         */

        /**
         * How the values in an image should be interpreted. For example, a
         * three-band float image of type [enum`Vips`.Interpretation.LAB] should have its
         * pixels interpreted as coordinates in CIE Lab space.
         *
         * RGB and sRGB are treated in the same way. Use the colourspace functions if
         * you want some other behaviour.
         *
         * The gaps in numbering are historical and must be maintained. Allocate
         * new numbers from the end.
         */
        export namespace Interpretation {
            export const $gtype: GObject.GType<Interpretation>;
        }

        enum Interpretation {
            ERROR,
            /**
             * generic many-band image
             */
            MULTIBAND,
            /**
             * some kind of single-band image
             */
            B_W,
            /**
             * a 1D image, eg. histogram or lookup table
             */
            HISTOGRAM,
            /**
             * the first three bands are CIE XYZ
             */
            XYZ,
            /**
             * pixels are in CIE Lab space
             */
            LAB,
            /**
             * the first four bands are in CMYK space
             */
            CMYK,
            /**
             * implies [enum`Vips`.Coding.LABQ]
             */
            LABQ,
            /**
             * generic RGB space
             */
            RGB,
            /**
             * a uniform colourspace based on CMC(1:1)
             */
            CMC,
            /**
             * pixels are in CIE LCh space
             */
            LCH,
            /**
             * CIE LAB coded as three signed 16-bit values
             */
            LABS,
            /**
             * pixels are sRGB
             */
            SRGB,
            /**
             * pixels are CIE Yxy
             */
            YXY,
            /**
             * image is in fourier space
             */
            FOURIER,
            /**
             * generic 16-bit RGB
             */
            RGB16,
            /**
             * generic 16-bit mono
             */
            GREY16,
            /**
             * a matrix
             */
            MATRIX,
            /**
             * pixels are scRGB
             */
            SCRGB,
            /**
             * pixels are HSV
             */
            HSV,
            LAST,
        }
        /**
         * The resampling kernels vips supports. See [method`Image`.reduce], for example.
         */

        /**
         * The resampling kernels vips supports. See [method`Image`.reduce], for example.
         */
        export namespace Kernel {
            export const $gtype: GObject.GType<Kernel>;
        }

        enum Kernel {
            /**
             * The nearest pixel to the point.
             */
            NEAREST,
            /**
             * Convolve with a triangle filter.
             */
            LINEAR,
            /**
             * Convolve with a cubic filter.
             */
            CUBIC,
            /**
             * Convolve with a Mitchell kernel.
             */
            MITCHELL,
            /**
             * Convolve with a two-lobe Lanczos kernel.
             */
            LANCZOS2,
            /**
             * Convolve with a three-lobe Lanczos kernel.
             */
            LANCZOS3,
            /**
             * Convolve with Magic Kernel Sharp 2013.
             */
            MKS2013,
            /**
             * Convolve with Magic Kernel Sharp 2021.
             */
            MKS2021,
            LAST,
        }
        /**
         * See also: [method`Image`.boolean].
         */

        /**
         * See also: [method`Image`.boolean].
         */
        export namespace OperationBoolean {
            export const $gtype: GObject.GType<OperationBoolean>;
        }

        enum OperationBoolean {
            /**
             * `&`
             */
            AND,
            /**
             * `|`
             */
            OR,
            /**
             * `^`
             */
            EOR,
            /**
             * `>>`
             */
            LSHIFT,
            /**
             * `<<`
             */
            RSHIFT,
            LAST,
        }
        /**
         * See also: [method`Image`.complex].
         */

        /**
         * See also: [method`Image`.complex].
         */
        export namespace OperationComplex {
            export const $gtype: GObject.GType<OperationComplex>;
        }

        enum OperationComplex {
            /**
             * convert to polar coordinates
             */
            POLAR,
            /**
             * convert to rectangular coordinates
             */
            RECT,
            /**
             * complex conjugate
             */
            CONJ,
            LAST,
        }
        /**
         * See also: [method`Image`.complex2].
         */

        /**
         * See also: [method`Image`.complex2].
         */
        export namespace OperationComplex2 {
            export const $gtype: GObject.GType<OperationComplex2>;
        }

        enum OperationComplex2 {
            /**
             * convert to polar coordinates
             */
            CROSS_PHASE,
            LAST,
        }
        /**
         * See also: [method`Image`.complexget].
         */

        /**
         * See also: [method`Image`.complexget].
         */
        export namespace OperationComplexget {
            export const $gtype: GObject.GType<OperationComplexget>;
        }

        enum OperationComplexget {
            /**
             * get real component
             */
            REAL,
            /**
             * get imaginary component
             */
            IMAG,
            LAST,
        }
        /**
         * See also: [method`Image`.math].
         */

        /**
         * See also: [method`Image`.math].
         */
        export namespace OperationMath {
            export const $gtype: GObject.GType<OperationMath>;
        }

        enum OperationMath {
            /**
             * `sin()`, angles in degrees
             */
            SIN,
            /**
             * `cos()`, angles in degrees
             */
            COS,
            /**
             * `tan()`, angles in degrees
             */
            TAN,
            /**
             * `asin()`, angles in degrees
             */
            ASIN,
            /**
             * `acos()`, angles in degrees
             */
            ACOS,
            /**
             * `atan()`, angles in degrees
             */
            ATAN,
            /**
             * log base e
             */
            LOG,
            /**
             * log base 10
             */
            LOG10,
            /**
             * e to the something
             */
            EXP,
            /**
             * 10 to the something
             */
            EXP10,
            /**
             * `sinh()`, angles in radians
             */
            SINH,
            /**
             * `cosh()`, angles in radians
             */
            COSH,
            /**
             * `tanh()`, angles in radians
             */
            TANH,
            /**
             * `asinh()`, angles in radians
             */
            ASINH,
            /**
             * `acosh()`, angles in radians
             */
            ACOSH,
            /**
             * `atanh()`, angles in radians
             */
            ATANH,
            LAST,
        }
        /**
         * See also: [method`Image`.math].
         */

        /**
         * See also: [method`Image`.math].
         */
        export namespace OperationMath2 {
            export const $gtype: GObject.GType<OperationMath2>;
        }

        enum OperationMath2 {
            /**
             * `pow(left, right)`
             */
            POW,
            /**
             * `pow(right, left)`
             */
            WOP,
            /**
             * `atan2(left, right)`
             */
            ATAN2,
            LAST,
        }
        /**
         * More like hit-miss, really.
         *
         * ::: seealso
         *     [method`Image`.morph].
         */

        /**
         * More like hit-miss, really.
         *
         * ::: seealso
         *     [method`Image`.morph].
         */
        export namespace OperationMorphology {
            export const $gtype: GObject.GType<OperationMorphology>;
        }

        enum OperationMorphology {
            /**
             * true if all set
             */
            ERODE,
            /**
             * true if one set
             */
            DILATE,
            LAST,
        }
        /**
         * See also: [method`Image`.relational].
         */

        /**
         * See also: [method`Image`.relational].
         */
        export namespace OperationRelational {
            export const $gtype: GObject.GType<OperationRelational>;
        }

        enum OperationRelational {
            /**
             * `==`
             */
            EQUAL,
            /**
             * `!=`
             */
            NOTEQ,
            /**
             * `<`
             */
            LESS,
            /**
             * `<=`
             */
            LESSEQ,
            /**
             * `>`
             */
            MORE,
            /**
             * `>=`
             */
            MOREEQ,
            LAST,
        }
        /**
         * See also: [method`Image`.round].
         */

        /**
         * See also: [method`Image`.round].
         */
        export namespace OperationRound {
            export const $gtype: GObject.GType<OperationRound>;
        }

        enum OperationRound {
            /**
             * round to nearest
             */
            RINT,
            /**
             * the smallest integral value not less than
             */
            CEIL,
            /**
             * largest integral value not greater than
             */
            FLOOR,
            LAST,
        }
        /**
         * Pick a Profile Connection Space for [method`Image`.icc_import] and
         * [method`Image`.icc_export]. LAB is usually best, XYZ can be more convenient in some
         * cases.
         */

        /**
         * Pick a Profile Connection Space for [method`Image`.icc_import] and
         * [method`Image`.icc_export]. LAB is usually best, XYZ can be more convenient in some
         * cases.
         */
        export namespace PCS {
            export const $gtype: GObject.GType<PCS>;
        }

        enum PCS {
            /**
             * use CIELAB D65 as the Profile Connection Space
             */
            LAB,
            /**
             * use XYZ as the Profile Connection Space
             */
            XYZ,
            LAST,
        }
        /**
         * How accurate an operation should be.
         */

        /**
         * How accurate an operation should be.
         */
        export namespace Precision {
            export const $gtype: GObject.GType<Precision>;
        }

        enum Precision {
            /**
             * int everywhere
             */
            INTEGER,
            /**
             * float everywhere
             */
            FLOAT,
            /**
             * approximate integer output
             */
            APPROXIMATE,
            LAST,
        }
        /**
         * How to calculate the output pixels when shrinking a 2x2 region.
         */

        /**
         * How to calculate the output pixels when shrinking a 2x2 region.
         */
        export namespace RegionShrink {
            export const $gtype: GObject.GType<RegionShrink>;
        }

        enum RegionShrink {
            /**
             * use the average
             */
            MEAN,
            /**
             * use the median
             */
            MEDIAN,
            /**
             * use the mode
             */
            MODE,
            /**
             * use the maximum
             */
            MAX,
            /**
             * use the minimum
             */
            MIN,
            /**
             * use the top-left pixel
             */
            NEAREST,
            LAST,
        }
        /**
         * The SDF to generate,
         *
         * ::: seealso
         *     [ctor`Image`.sdf].
         */

        /**
         * The SDF to generate,
         *
         * ::: seealso
         *     [ctor`Image`.sdf].
         */
        export namespace SdfShape {
            export const $gtype: GObject.GType<SdfShape>;
        }

        enum SdfShape {
            /**
             * a circle at `a,` radius `r`
             */
            CIRCLE,
            /**
             * a box from `a` to `b`
             */
            BOX,
            /**
             * a box with rounded `corners` from `a` to `b`
             */
            ROUNDED_BOX,
            /**
             * a line from `a` to `b`
             */
            LINE,
            LAST,
        }
        /**
         * Controls whether an operation should upsize, downsize, both up and
         * downsize, or force a size.
         *
         * ::: seealso
         *     [ctor`Image`.thumbnail].
         */

        /**
         * Controls whether an operation should upsize, downsize, both up and
         * downsize, or force a size.
         *
         * ::: seealso
         *     [ctor`Image`.thumbnail].
         */
        export namespace Size {
            export const $gtype: GObject.GType<Size>;
        }

        enum Size {
            /**
             * size both up and down
             */
            BOTH,
            /**
             * only upsize
             */
            UP,
            /**
             * only downsize
             */
            DOWN,
            /**
             * force size, that is, break aspect ratio
             */
            FORCE,
            LAST,
        }
        /**
         * Sets the word wrapping style for [ctor`Image`.text] when used with a maximum
         * width.
         *
         * ::: seealso
         *     [ctor`Image`.text].
         */

        /**
         * Sets the word wrapping style for [ctor`Image`.text] when used with a maximum
         * width.
         *
         * ::: seealso
         *     [ctor`Image`.text].
         */
        export namespace TextWrap {
            export const $gtype: GObject.GType<TextWrap>;
        }

        enum TextWrap {
            /**
             * wrap at word boundaries
             */
            WORD,
            /**
             * wrap at character boundaries
             */
            CHAR,
            /**
             * wrap at word boundaries, but fall back to character boundaries if there is not enough space for a full word
             */
            WORD_CHAR,
            /**
             * no wrapping
             */
            NONE,
            LAST,
        }
        /**
         * Tokens returned by the vips lexical analyzer, see vips__token_get(). This
         * is used to parse option strings for arguments.
         *
         * Left and right brackets can be any of (, {, [, <.
         *
         * Strings may be in double quotes, and may contain escaped quote characters,
         * for example string, "string" and "str\"ing".
         */

        /**
         * Tokens returned by the vips lexical analyzer, see vips__token_get(). This
         * is used to parse option strings for arguments.
         *
         * Left and right brackets can be any of (, {, [, <.
         *
         * Strings may be in double quotes, and may contain escaped quote characters,
         * for example string, "string" and "str\"ing".
         */
        export namespace Token {
            export const $gtype: GObject.GType<Token>;
        }

        enum Token {
            /**
             * left bracket
             */
            LEFT,
            /**
             * right bracket
             */
            RIGHT,
            /**
             * string constant
             */
            STRING,
            /**
             * equals sign
             */
            EQUALS,
            /**
             * comma
             */
            COMMA,
        }
        const ARGUMENT_OPTIONAL_INPUT: number;
        const ARGUMENT_OPTIONAL_OUTPUT: number;
        const ARGUMENT_REQUIRED_INPUT: number;
        const ARGUMENT_REQUIRED_OUTPUT: number;
        /**
         * Areas under curves for illuminant A (2856K), 2 degree observer.
         */
        const A_X0: number;
        const A_Y0: number;
        const A_Z0: number;
        /**
         * Areas under curves for illuminant B (4874K), 2 degree observer.
         */
        const B_X0: number;
        const B_Y0: number;
        const B_Z0: number;
        const CONFIG: string;
        /**
         * Areas under curves for illuminant C (6774K), 2 degree observer.
         */
        const C_X0: number;
        const C_Y0: number;
        const C_Z0: number;
        /**
         * Areas under curves for black body at 3250K, 2 degree observer.
         */
        const D3250_X0: number;
        const D3250_Y0: number;
        const D3250_Z0: number;
        /**
         * Areas under curves for D50, 2 degree observer.
         */
        const D50_X0: number;
        const D50_Y0: number;
        const D50_Z0: number;
        /**
         * Areas under curves for D55, 2 degree observer.
         */
        const D55_X0: number;
        const D55_Y0: number;
        const D55_Z0: number;
        /**
         * Areas under curves for D65, 2 degree observer.
         */
        const D65_X0: number;
        const D65_Y0: number;
        const D65_Z0: number;
        /**
         * Areas under curves for D75, 2 degree observer.
         */
        const D75_X0: number;
        const D75_Y0: number;
        const D75_Z0: number;
        /**
         * Areas under curves for D93, 2 degree observer.
         */
        const D93_X0: number;
        const D93_Y0: number;
        const D93_Z0: number;
        const DEFAULT_MAX_COORD: number;
        const ENABLE_DEPRECATED: number;
        /**
         * Areas under curves for equal energy illuminant E.
         */
        const E_X0: number;
        const E_Y0: number;
        const E_Z0: number;
        /**
         * [const`INTERPOLATE_SHIFT]` as a multiplicative constant.
         */
        const INTERPOLATE_SCALE: number;
        /**
         * Many of the vips interpolators use fixed-point arithmetic for value
         * calculation. This is how many bits of precision they use.
         */
        const INTERPOLATE_SHIFT: number;
        const LIBRARY_AGE: number;
        const LIBRARY_CURRENT: number;
        const LIBRARY_REVISION: number;
        /**
         * The first four bytes of a VIPS file in Intel byte ordering.
         */
        const MAGIC_INTEL: number;
        /**
         * The first four bytes of a VIPS file in SPARC byte ordering.
         */
        const MAGIC_SPARC: number;
        const MAJOR_VERSION: number;
        /**
         * The bits per sample for each channel.
         */
        const META_BITS_PER_SAMPLE: string;
        /**
         * If set, the suggested concurrency for this image.
         */
        const META_CONCURRENCY: string;
        /**
         * The name that read and write operations use for the image's EXIF data.
         */
        const META_EXIF_NAME: string;
        /**
         * The name we use to attach an ICC profile. The file read and write
         * operations for TIFF, JPEG, PNG and others use this item of metadata to
         * attach and save ICC profiles. The profile is updated by the
         * [method`Image`.icc_transform] operations.
         */
        const META_ICC_NAME: string;
        /**
         * The IMAGEDESCRIPTION tag. Often has useful metadata.
         */
        const META_IMAGEDESCRIPTION: string;
        /**
         * The name that read and write operations use for the image's IPTC data.
         */
        const META_IPTC_NAME: string;
        /**
         * Record the name of the original loader here. Handy for hinting file formats
         * and for debugging.
         */
        const META_LOADER: string;
        /**
         * If set, the number of pages in the original file.
         */
        const META_N_PAGES: string;
        /**
         * If set, the number of subifds in the first page of the file.
         */
        const META_N_SUBIFDS: string;
        /**
         * The orientation tag for this image. An int from 1 - 8 using the standard
         * exif/tiff meanings.
         *
         * - 1 - The 0th row represents the visual top of the image, and the 0th column
         *   represents the visual left-hand side.
         * - 2 - The 0th row represents the visual top of the image, and the 0th column
         *   represents the visual right-hand side.
         * - 3 - The 0th row represents the visual bottom of the image, and the 0th
         *   column represents the visual right-hand side.
         * - 4 - The 0th row represents the visual bottom of the image, and the 0th
         *   column represents the visual left-hand side.
         * - 5 - The 0th row represents the visual left-hand side of the image, and the
         *   0th column represents the visual top.
         * - 6 - The 0th row represents the visual right-hand side of the image, and the
         *   0th column represents the visual top.
         * - 7 - The 0th row represents the visual right-hand side of the image, and the
         *   0th column represents the visual bottom.
         * - 8 - The 0th row represents the visual left-hand side of the image, and the
         *   0th column represents the visual bottom.
         */
        const META_ORIENTATION: string;
        /**
         * If set, the height of each page when this image was loaded. If you save an
         * image with "page-height" set to a format that supports multiple pages, such
         * as tiff, the image will be saved as a series of pages.
         */
        const META_PAGE_HEIGHT: string;
        /**
         * Does this image have a palette?
         */
        const META_PALETTE: string;
        /**
         * The name that TIFF read and write operations use for the image's
         * TIFFTAG_PHOTOSHOP data.
         */
        const META_PHOTOSHOP_NAME: string;
        /**
         * The JPEG and TIFF read and write operations use this to record the
         * file's preferred unit for resolution.
         */
        const META_RESOLUTION_UNIT: string;
        /**
         * Images loaded via [method`Image`.sequential] have this int field defined. Some
         * operations (eg. [method`Image`.shrinkv]) add extra caches if they see it on their
         * input.
         */
        const META_SEQUENTIAL: string;
        /**
         * The name that read and write operations use for the image's XMP data.
         */
        const META_XMP_NAME: string;
        const MICRO_VERSION: number;
        const MINOR_VERSION: number;
        const PATH_MAX: number;
        const PI: number;
        const SBUF_BUFFER_SIZE: number;
        const TARGET_BUFFER_SIZE: number;
        const TARGET_CUSTOM_BUFFER_SIZE: number;
        /**
         * [const`TRANSFORM_SHIFT]` as a multiplicative constant.
         */
        const TRANSFORM_SCALE: number;
        /**
         * Many of the libvips interpolators use fixed-point arithmetic for coordinate
         * calculation. This is how many bits of precision they use.
         */
        const TRANSFORM_SHIFT: number;
        const VERSION: string;
        const VERSION_STRING: string;
        /**
         * Add the standard vips [struct`GLib`.OptionEntry] to a
         * [struct`GLib`.OptionGroup].
         *
         * ::: seealso
         *     [ctor`GLib`.OptionGroup.new].
         * @param option_group group to add to
         */
        function add_option_entries(option_group: GLib.OptionGroup): void;
        function amiMSBfirst(): number;
        function area_free_cb(mem: any | null, area: Area): number;
        /**
         * Loop over the [struct`Argument]` of an object. Stop when `fn` returns non-`NULL`
         * and return that value.
         * @param object object whose args should be enumerated
         * @param fn call this function for every argument
         * @param b client data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function argument_map(object: Object, fn: ArgumentMapFn, b?: any | null): any | null;
        /**
         * Return `TRUE` if `format` is uchar or schar.
         * @param format format to test
         */
        function band_format_is8bit(format: BandFormat | null): boolean;
        /**
         * Return `TRUE` if `fmt` is one of the complex types.
         * @param format format to test
         */
        function band_format_iscomplex(format: BandFormat | null): boolean;
        /**
         * Return `TRUE` if `format` is one of the float types.
         * @param format format to test
         */
        function band_format_isfloat(format: BandFormat | null): boolean;
        /**
         * Return `TRUE` if `format` is one of the integer types.
         * @param format format to test
         */
        function band_format_isint(format: BandFormat | null): boolean;
        /**
         * Return `TRUE` if `format` is one of the unsigned integer types.
         * @param format format to test
         */
        function band_format_isuint(format: BandFormat | null): boolean;
        /**
         * Like [ctor`Blob`.new], but take a copy of the data. Useful for bindings
         * which struggle with callbacks.
         *
         * ::: seealso
         *     [ctor`Blob`.new].
         * @param data data to store
         * @returns the new [struct@Blob].
         */
        function blob_copy(data: Uint8Array | string): Blob;
        /**
         * Set the block state on all untrusted operations.
         *
         * ```c
         * vips_block_untrusted_set(TRUE);
         * ```
         *
         * Will block all untrusted operations from running.
         *
         * Use `vips -l` at the command-line to see the class hierarchy and which
         * operations are marked as untrusted.
         *
         * Set the environment variable `VIPS_BLOCK_UNTRUSTED` to block all untrusted
         * operations on [func`init]`.
         * @param state the block state to set
         */
        function block_untrusted_set(state: boolean): void;
        function break_token(str: string, brk: string): string;
        /**
         * Drop the whole operation cache, handy for leak tracking. Also called
         * automatically on [func`shutdown]`.
         */
        function cache_drop_all(): void;
        /**
         * Get the maximum number of operations we keep in cache.
         * @returns the maximum number of operations we keep in cache
         */
        function cache_get_max(): number;
        /**
         * Get the maximum number of tracked files we allow before we start dropping
         * cached operations. See [func`tracked_get_files]`.
         *
         * libvips only tracks file descriptors it allocates, it can't track ones
         * allocated by external libraries. If you use an operation like
         * [ctor`Image`.magickload], most of the descriptors it uses won't be included.
         *
         * ::: seealso
         *     [func`tracked_get_files]`.
         * @returns the maximum number of tracked files we allow
         */
        function cache_get_max_files(): number;
        /**
         * Get the maximum amount of tracked memory we allow before we start dropping
         * cached operations. See [func`tracked_get_mem]`.
         *
         * ::: seealso
         *     [func`tracked_get_mem]`.
         * @returns the maximum amount of tracked memory we allow
         */
        function cache_get_max_mem(): number;
        /**
         * Get the current number of operations in cache.
         * @returns get the current number of operations in cache.
         */
        function cache_get_size(): number;
        /**
         * A binding-friendly version of [func`cache_operation_buildp]`.
         *
         * After calling this, `operation` has the same ref count as when it went in,
         * and the result must be freed with [method`Object`.unref_outputs] and
         * [method`GObject`.Object.unref].
         * @param operation operation to lookup
         * @returns The built operation.
         */
        function cache_operation_build(operation: Operation): Operation;
        /**
         * Print the whole operation cache to stdout. Handy for debugging.
         */
        function cache_print(): void;
        /**
         * Handy for debugging. Print the operation cache to stdout just before exit.
         *
         * ::: seealso
         *     [func`cache_set_trace]`.
         * @param dump if `TRUE`, dump the operation cache on exit
         */
        function cache_set_dump(dump: boolean): void;
        /**
         * Set the maximum number of operations we keep in cache.
         * @param max maximum number of operation to cache
         */
        function cache_set_max(max: number): void;
        /**
         * Set the maximum number of tracked files we allow before we start dropping
         * cached operations. See [func`tracked_get_files]`.
         *
         * ::: seealso
         *     [func`tracked_get_files]`.
         * @param max_files max open files we allow
         */
        function cache_set_max_files(max_files: number): void;
        /**
         * Set the maximum amount of tracked memory we allow before we start dropping
         * cached operations. See [func`tracked_get_mem]`.
         *
         * libvips only tracks memory it allocates, it can't track memory allocated by
         * external libraries. If you use an operation like [ctor`Image`.magickload],
         * most of the memory it uses won't be included.
         *
         * ::: seealso
         *     [func`tracked_get_mem]`.
         * @param max_mem maximum amount of tracked memory we use
         */
        function cache_set_max_mem(max_mem: number): void;
        /**
         * Handy for debugging. Print operation cache actions to stdout as we run.
         *
         * You can set the environment variable `VIPS_TRACE` to turn this option on, or
         * use the command-line flag `--vips-cache-trace`.
         *
         * ::: seealso
         *     [func`cache_set_dump]`.
         * @param trace if `TRUE`, trace the operation cache
         */
        function cache_set_trace(trace: boolean): void;
        function call_argv(operation: Operation, argc: number, argv: string): number;
        function call_options(group: GLib.OptionGroup, operation: Operation): void;
        /**
         * Check that the image is 8 or 16-bit integer, signed or unsigned.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_8or16(domain: string, im: Image): number;
        /**
         * `bandno` should be a valid band number (ie. 0 to im->Bands - 1), or can be
         * -1, meaning all bands.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param bandno band number
         * @returns 0 if OK, -1 otherwise.
         */
        function check_bandno(domain: string, im: Image, bandno: number): number;
        /**
         * Check that the image has `bands` bands.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param bands must have this many bands
         * @returns 0 if OK, -1 otherwise.
         */
        function check_bands(domain: string, im: Image, bands: number): number;
        /**
         * Check that the image has either one or three bands.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_bands_1or3(domain: string, im: Image): number;
        /**
         * Check that the images have the same number of bands, or that one of the
         * images has just 1 band.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im1 first image to check
         * @param im2 second image to check
         * @returns 0 on OK, or -1 on error.
         */
        function check_bands_1orn(domain: string, im1: Image, im2: Image): number;
        /**
         * Check that an image has 1 or `n` bands. Handy for unary operations, cf.
         * [func`check_bands_1`orn].
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`check_bands_1`orn].
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param n number of bands, or 1
         * @returns 0 on OK, or -1 on error.
         */
        function check_bands_1orn_unary(domain: string, im: Image, n: number): number;
        /**
         * Check that the image has at least `bands` bands.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param bands at least this many bands
         * @returns 0 if OK, -1 otherwise.
         */
        function check_bands_atleast(domain: string, im: Image, bands: number): number;
        /**
         * Check that the images have the same number of bands.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im1 first image to check
         * @param im2 second image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_bands_same(domain: string, im1: Image, im2: Image): number;
        /**
         * Check that the image has the required `coding`.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param coding required coding
         * @returns 0 on OK, or -1 on error.
         */
        function check_coding(domain: string, im: Image, coding: Coding | null): number;
        /**
         * Check that the image is uncoded, LABQ coded or RAD coded.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 on OK, or -1 on error.
         */
        function check_coding_known(domain: string, im: Image): number;
        /**
         * Check that the image is uncoded or LABQ coded.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 on OK, or -1 on error.
         */
        function check_coding_noneorlabq(domain: string, im: Image): number;
        /**
         * Check that the images have the same coding.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im1 first image to check
         * @param im2 second image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_coding_same(domain: string, im1: Image, im2: Image): number;
        /**
         * Check that the image is complex.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_complex(domain: string, im: Image): number;
        /**
         * Check that the image has the specified format.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @param fmt format to test for
         * @returns 0 if OK, -1 otherwise.
         */
        function check_format(domain: string, im: Image, fmt: BandFormat | null): number;
        /**
         * Check that the images have the same format.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im1 first image to check
         * @param im2 second image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_format_same(domain: string, im1: Image, im2: Image): number;
        /**
         * Histogram images must have width or height 1, and must not have more than
         * 65536 elements. Return 0 if the image will pass as a histogram, or -1 and
         * set an error message otherwise.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_hist(domain: string, im: Image): number;
        /**
         * Check that the image is in one of the integer formats.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_int(domain: string, im: Image): number;
        /**
         * Matrix images must have width and height less than 100000 and have 1 band.
         *
         * Return 0 if the image will pass as a matrix, or -1 and set an error
         * message otherwise.
         *
         * `out` is set to be `im` cast to double and stored in memory. Use
         * [func`MATRIX]` to address values in `out`.
         *
         * You must unref `out` when you are done with it.
         *
         * ::: seealso
         *     [func`MATRIX]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_matrix(domain: string, im: Image): [number, Image];
        /**
         * Check that the image has exactly one band.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_mono(domain: string, im: Image): number;
        /**
         * Check that the image is not complex.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_noncomplex(domain: string, im: Image): number;
        /**
         * Check that the image is square and that the sides are odd.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_oddsquare(domain: string, im: Image): number;
        /**
         * Check that `prec` image is either float or int.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param precision precision to check
         * @returns 0 on OK, or -1 on error.
         */
        function check_precision_intfloat(domain: string, precision: Precision | null): number;
        /**
         * Separable matrix images must have width or height 1.
         * Return 0 if the image will pass, or -1 and
         * set an error message otherwise.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_separable(domain: string, im: Image): number;
        /**
         * Check that the images have the same size.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im1 first image to check
         * @param im2 second image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_size_same(domain: string, im1: Image, im2: Image): number;
        /**
         * Check that the image is has two "components", ie. is a one-band complex or
         * a two-band non-complex.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_twocomponents(domain: string, im: Image): number;
        /**
         * Check that the image is 8 or 16-bit unsigned integer.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_u8or16(domain: string, im: Image): number;
        /**
         * Check that the image is 8 or 16-bit unsigned integer, or float.
         * Otherwise set an error message and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_u8or16orf(domain: string, im: Image): number;
        /**
         * Check that the image is in one of the unsigned integer formats.
         * Otherwise set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_uint(domain: string, im: Image): number;
        /**
         * Check that the image is unsigned int or float.
         * Otherwise set an error message and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 if OK, -1 otherwise.
         */
        function check_uintorf(domain: string, im: Image): number;
        /**
         * Check that the image is not coded.
         * If not, set an error message
         * and return non-zero.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param im image to check
         * @returns 0 on OK, or -1 on error.
         */
        function check_uncoded(domain: string, im: Image): number;
        /**
         * Operations with a vector constant need a 1-element vector, or a vector with
         * the same number of elements as there are bands in the image, or a 1-band
         * image and a many-element vector.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param n number of elements in vector
         * @param im image to check against
         * @returns 0 if OK, -1 otherwise.
         */
        function check_vector(domain: string, n: number, im: Image): number;
        /**
         * Check that `n` == `len`.
         *
         * ::: seealso
         *     [func`error]`.
         * @param domain the originating domain for the error message
         * @param n number of elements in vector
         * @param len number of elements vector should have
         * @returns 0 if OK, -1 otherwise.
         */
        function check_vector_length(domain: string, n: number, len: number): number;
        /**
         * Search below `basename,` return the first class whose name or `nickname`
         * matches.
         *
         * ::: seealso
         *     [func`type_find]`
         * @param basename name of base class
         * @param nickname search for a class with this nickname
         * @returns the found class.
         */
        function class_find(basename: string, nickname: string): typeof Object;
        /**
         * Calculate Ccmc from C.
         * @param C Chroma
         * @returns Ccmc.
         */
        function col_C2Ccmc(C: number): number;
        /**
         * Calculate C from Ccmc using a table.
         * Call [func`col_make_tables_CMC]` at
         * least once before using this function.
         * @param Ccmc Ccmc
         * @returns C.
         */
        function col_Ccmc2C(Ccmc: number): number;
        /**
         * Calculate ab from Ch, h in degrees.
         * @param C Chroma
         * @param h Hue angle (degrees)
         * @param a return CIE a* value
         * @param b return CIE b* value
         */
        function col_Ch2ab(C: number, h: number, a: number, b: number): void;
        /**
         * Calculate hcmc from C and h.
         * @param C Chroma
         * @param h Hue (degrees)
         * @returns hcmc.
         */
        function col_Ch2hcmc(C: number, h: number): number;
        /**
         * Calculate h from C and hcmc, using a table.
         * Call [func`col_make_tables_CMC]` at
         * least once before using this function.
         * @param C Chroma
         * @param hcmc Hue cmc (degrees)
         * @returns h.
         */
        function col_Chcmc2h(C: number, hcmc: number): number;
        /**
         * Calculate Lcmc from L.
         * @param L CIE L*
         * @returns Lcmc
         */
        function col_L2Lcmc(L: number): number;
        /**
         * Calculate XYZ from Lab, D65.
         *
         * ::: seealso
         *     [method`Image`.Lab2XYZ].
         * @param L Input CIE Lab value
         * @param a Input CIE Lab value
         * @param b Input CIE Lab value
         */
        function col_Lab2XYZ(L: number, a: number, b: number): [number, number, number];
        /**
         * Calculate L from Lcmc using a table. Call [func`col_make_tables_CMC]` at
         * least once before using this function.
         * @param Lcmc L cmc
         * @returns L*
         */
        function col_Lcmc2L(Lcmc: number): number;
        /**
         * Calculate XYZ from Lab, D65.
         *
         * ::: seealso
         *     [method`Image`.XYZ2Lab].
         * @param X Input CIE XYZ colour
         * @param Y Input CIE XYZ colour
         * @param Z Input CIE XYZ colour
         */
        function col_XYZ2Lab(X: number, Y: number, Z: number): [number, number, number];
        /**
         * Turn XYZ into scRGB.
         *
         * ::: seealso
         *     [method`Image`.XYZ2scRGB].
         * @param X Input XYZ value
         * @param Y Input XYZ value
         * @param Z Input XYZ value
         */
        function col_XYZ2scRGB(X: number, Y: number, Z: number): [number, number, number, number];
        function col_ab2Ch(a: number, b: number, C: number, h: number): void;
        function col_ab2h(a: number, b: number): number;
        /**
         * CIEDE2000, from:
         *
         * Luo, Cui, Rigg, "The Development of the CIE 2000 Colour-Difference
         * Formula: CIEDE2000", COLOR research and application, pp 340
         * @param L1 Input coordinate 1
         * @param a1 Input coordinate 1
         * @param b1 Input coordinate 1
         * @param L2 Input coordinate 2
         * @param a2 Input coordinate 2
         * @param b2 Input coordinate 2
         * @returns CIE dE2000 colour difference.
         */
        function col_dE00(L1: number, a1: number, b1: number, L2: number, a2: number, b2: number): number;
        /**
         * Make the lookup tables for cmc.
         */
        function col_make_tables_CMC(): void;
        function col_sRGB2scRGB_16(r: number, g: number, b: number, R: number, G: number, B: number): number;
        function col_sRGB2scRGB_16_noclip(r: number, g: number, b: number, R: number, G: number, B: number): number;
        function col_sRGB2scRGB_8(r: number, g: number, b: number, R: number, G: number, B: number): number;
        function col_sRGB2scRGB_8_noclip(r: number, g: number, b: number, R: number, G: number, B: number): number;
        function col_scRGB2BW_16(R: number, G: number, B: number, g: number, og: number): number;
        function col_scRGB2BW_8(R: number, G: number, B: number, g: number, og: number): number;
        /**
         * Turn scRGB into XYZ.
         *
         * ::: seealso
         *     [method`Image`.scRGB2XYZ].
         * @param R Input scRGB value
         * @param G Input scRGB value
         * @param B Input scRGB value
         */
        function col_scRGB2XYZ(R: number, G: number, B: number): [number, number, number, number];
        function col_scRGB2sRGB_16(
            R: number,
            G: number,
            B: number,
            r: number,
            g: number,
            b: number,
            og: number,
        ): number;
        function col_scRGB2sRGB_8(R: number, G: number, B: number, r: number, g: number, b: number, og: number): number;
        /**
         * Returns the number of worker threads that vips should use when running
         * [func`threadpool_run]`.
         *
         * vips gets this values from these sources in turn:
         *
         * If [func`concurrency_set]` has been called, this value is used. The special
         * value 0 means "default". You can also use the command-line argument
         * `--vips-concurrency` to set this value.
         *
         * If [func`concurrency_set]` has not been called and no command-line argument
         * was used, vips uses the value of the environment variable `VIPS_CONCURRENCY`.
         *
         * If `VIPS_CONCURRENCY` has not been set, vips finds the number of hardware
         * threads that the host machine can run in parallel and uses that value.
         *
         * The final value is clipped to the range 1 - 1024.
         *
         * ::: seealso
         *     [func`concurrency_get]`.
         * @returns number of worker threads to use.
         */
        function concurrency_get(): number;
        /**
         * Sets the number of worker threads that vips should use when running
         * [func`threadpool_run]`.
         *
         * The special value 0 means "default". In this case, the number of threads
         * is set by the environment variable `VIPS_CONCURRENCY`, or if that is not
         * set, the number of threads available on the host machine.
         *
         * ::: seealso
         *     [func`concurrency_get]`.
         * @param concurrency number of threads to run
         */
        function concurrency_set(concurrency: number): void;
        function enum_from_nick(domain: string, type: GObject.GType, str: string): number;
        function enum_nick(enm: GObject.GType, value: number): string;
        function enum_string(enm: GObject.GType, value: number): string;
        /**
         * Get a pointer to the start of the error buffer as a C string.
         * The string is owned by the error system and must not be freed.
         *
         * ::: seealso
         *     [func`error_clear]`.
         * @returns the error buffer as a C string which must not be freed
         */
        function error_buffer(): string;
        /**
         * Return a copy of the vips error buffer, and clear it.
         * @returns a copy of the libvips error buffer
         */
        function error_buffer_copy(): string;
        /**
         * Clear and reset the error buffer. This is typically called after presenting
         * an error to the user.
         *
         * ::: seealso
         *     [func`error_buffer]`.
         */
        function error_clear(): void;
        /**
         * Stop errors being logged. Use [func`error_thaw]` to unfreeze. You can
         * nest freeze/thaw pairs.
         */
        function error_freeze(): void;
        /**
         * This function sets the glib error pointer from the vips error buffer and
         * clears it. It's handy for returning errors to glib functions from vips.
         *
         * See [func`g_error]` for the inverse operation.
         *
         * ::: seealso
         *     [func`GLib`.set_error], [func`g_error]`.
         */
        function error_g(): void;
        /**
         * Re-enable error logging.
         */
        function error_thaw(): void;
        function file_length(fd: number): number;
        /**
         * Given a vips filename like "fred.jpg[Q=90]", return a new string of
         * just the filename part, "fred.jpg" in this case.
         *
         * Useful for language bindings.
         *
         * ::: seealso
         *     [func`filename_get_options]`.
         * @param vips_filename a filename including a set of options
         * @returns transfer full: just the filename component.
         */
        function filename_get_filename(vips_filename: string): string;
        /**
         * Given a vips filename like "fred.jpg[Q=90]", return a new string of
         * just the options part, "[Q=90]" in this case.
         *
         * Useful for language bindings.
         *
         * ::: seealso
         *     [func`filename_get_filename]`.
         * @param vips_filename a filename including a set of options
         * @returns transfer full: just the options component.
         */
        function filename_get_options(vips_filename: string): string;
        function filename_suffix_match(path: string, suffixes: string): number;
        function flags_from_nick(domain: string, type: GObject.GType, nick: string): number;
        /**
         * Return the flags for `filename` using `loader`.
         * `loader` is something like "tiffload" or "VipsForeignLoadTiff".
         * @param loader name of loader to use for test
         * @param filename file to test
         * @returns the flags for @filename.
         */
        function foreign_flags(loader: string, filename: string): ForeignFlags;
        function format_sizeof(format: BandFormat | null): number;
        /**
         * This function adds the [struct`GLib`.Error] to the vips error buffer and clears it. It's
         * the opposite of [func`error_g]`.
         *
         * ::: seealso
         *     [func`error_g]`.
         */
        function g_error(): void;
        /**
         * Create a new [class`Gio`.InputStream] wrapping a [class`Source]`. This is
         * useful for loaders like SVG and PDF which support [class`Gio`.InputStream]
         * methods.
         *
         * ::: seealso
         *     [func`Source`.g_input_stream_new]
         * @param source vips source to wrap
         * @returns a new [class@Gio.InputStream]
         */
        function g_input_stream_new_from_source(source: Source): Gio.InputStream;
        /**
         * Wrapper for [ctor`GLib`.Thread.try_new].
         * @param domain an (optional) name for the new thread
         * @param func a function to execute in the new thread
         * @returns the new [struct@GLib.Thread], or `NULL` if an error occurred
         */
        function g_thread_new(domain: string | null, func: GLib.ThreadFunc): GLib.Thread;
        /**
         * ::: seealso
         *     [func`INIT]`.
         * @returns a pointer to an internal copy of the argv0 string passed to [func@INIT]. Do not free this value
         */
        function get_argv0(): string;
        /**
         * Return the number of bytes at which we flip between open via memory and
         * open via disc. This defaults to 100mb, but can be changed with the
         * `VIPS_DISC_THRESHOLD` environment variable or the `--vips-disc-threshold`
         * command-line flag. See [ctor`Image`.new_from_file].
         * @returns disc threshold in bytes.
         */
        function get_disc_threshold(): number;
        /**
         * Return the program name.
         *
         * ::: seealso
         *     [func`INIT]`.
         * @returns a pointer to an internal copy of the program name. Do not free this value
         */
        function get_prgname(): string;
        /**
         * [func`guess_libdir]` tries to guess the install directory (usually the
         * configure libdir, or $prefix/lib). You should pass
         * in the value of argv[0] (the name your program was run as) as a clue to
         * help it out, plus the name of the environment variable you let the user
         * override your package install area with (eg. "VIPSHOME").
         *
         * On success, [func`guess_libdir]` returns the libdir it discovered, and as a
         * side effect, sets the prefix environment variable (if it's not set).
         *
         * Don't free the return string!
         *
         * ::: seealso
         *     [func`guess_prefix]`.
         * @param argv0 program name (typically argv[0])
         * @param env_name save prefix in this environment variable
         * @returns the libdir as a static string, do not free.
         */
        function guess_libdir(argv0: string, env_name: string): string;
        /**
         * [func`guess_prefix]` tries to guess the install directory. You should pass
         * in the value of argv[0] (the name your program was run as) as a clue to
         * help it out, plus the name of the environment variable you let the user
         * override your package install area with (eg. "VIPSHOME").
         *
         * On success, [func`guess_prefix]` returns the prefix it discovered, and as a
         * side effect, sets the environment variable (if it's not set).
         *
         * Don't free the return string!
         *
         * ::: seealso
         *     [func`guess_libdir]`.
         * @param argv0 program name (typically argv[0])
         * @param env_name save prefix in this environment variable
         * @returns the install prefix as a static string, do not free.
         */
        function guess_prefix(argv0: string, env_name: string): string;
        /**
         * Like slist map, but for a hash table.
         * @param hash a [struct@GLib.HashTable]
         * @param fn function to apply to each hash value
         * @param a user data
         * @param b user data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function hash_table_map(
            hash: { [key: string]: any } | GLib.HashTable<any, any>,
            fn: SListMap2Fn,
            a?: any | null,
            b?: any | null,
        ): any | null;
        function icc_is_compatible_profile(image: Image, data: any | null, data_length: number): boolean;
        /**
         * VIPS can optionally be built without the ICC library. Use this function to
         * test for its availability.
         * @returns non-zero if the ICC library is present.
         */
        function icc_present(): number;
        /**
         * This function starts up libvips, see [func`INIT]`.
         *
         * This function is for bindings which need to start up vips. C programs
         * should use the [func`INIT]` macro, which does some extra checks.
         *
         * ::: seealso
         *     [func`INIT]`.
         * @param argv0 name of application
         * @returns 0 on success, -1 otherwise
         */
        function init(argv0: string): number;
        function interpretation_max_alpha(interpretation: Interpretation | null): number;
        function iscasepostfix(a: string, b: string): boolean;
        function ispoweroftwo(p: number): number;
        function isprefix(a: string, b: string): boolean;
        /**
         * Turn on or off vips leak checking. See also `--vips-leak`,
         * [func`add_option_entries]` and the `VIPS_LEAK` environment variable.
         *
         * You should call this very early in your program.
         * @param leak turn leak checking on or off
         */
        function leak_set(leak: boolean): void;
        /**
         * [func`GLib`.malloc] local to `object,` that is, the memory will be automatically
         * freed for you when the object is closed. If `object` is `NULL`, you need to
         * free the memory explicitly with [func`GLib`.free].
         *
         * This function cannot fail. See [func`tracked_malloc]` if you are
         * allocating large amounts of memory.
         *
         * ::: seealso
         *     [func`tracked_malloc]`.
         * @param object allocate memory local to this [class@Object], or `NULL`
         * @param size number of bytes to allocate
         * @returns a pointer to the allocated memory.
         */
        function malloc(object: Object | null, size: number): any | null;
        function map_equal(a?: any | null, b?: any | null): any | null;
        /**
         * Return the maximum coordinate value. This can be the default, a value set
         * set by the `--vips-max-coord` CLI arg, or a value set in the `VIPS_MAX_COORD`
         * environment variable.
         *
         * These strings can include unit specifiers, eg. "10m" for 10 million pixels.
         * Values above INT_MAX are not supported.
         * @returns The maximum value a coordinate, or image dimension, can have.
         */
        function max_coord_get(): number;
        /**
         * Return the VIPS nickname for a [alias`GObject`.Type]. Handy for language bindings.
         * @param type [alias@GObject.Type] to search for
         * @returns the class nickname.
         */
        function nickname_find(type: GObject.GType): string;
        /**
         * If a source does not support mmap or seek and the source is
         * used with a loader that can only work from memory, then the data will be
         * automatically read into memory to EOF before the loader starts. This can
         * produce high memory use if the descriptor represents a large object.
         *
         * Use [func`pipe_read_limit_set]` to limit the size of object that
         * will be read in this way. The default is 1GB.
         *
         * Set a value of -1 to mean no limit.
         *
         * ::: seealso
         *     `--vips-pipe-read-limit` and the environment variable
         *     `VIPS_PIPE_READ_LIMIT`.
         * @param limit maximum number of bytes to buffer from a pipe
         */
        function pipe_read_limit_set(limit: number): void;
        /**
         * If set, vips will record profiling information, and dump it on program
         * exit. These profiles can be analysed with the `vipsprofile` program.
         * @param profile `TRUE` to enable profile recording
         */
        function profile_set(profile: boolean): void;
        /**
         * If set, vips will print messages about the progress of computation to
         * stdout. This can also be enabled with the `--vips-progress` option, or by
         * setting the environment variable `VIPS_PROGRESS`.
         * @param progress `TRUE` to enable progress messages
         */
        function progress_set(progress: boolean): void;
        /**
         * Pythagorean distance between two points in colour space. Lab/XYZ/CMC etc.
         * @param L1 Input coordinate 1
         * @param a1 Input coordinate 1
         * @param b1 Input coordinate 1
         * @param L2 Input coordinate 2
         * @param a2 Input coordinate 2
         * @param b2 Input coordinate 2
         */
        function pythagoras(L1: number, a1: number, b1: number, L2: number, a2: number, b2: number): number;
        function realpath(path: string): string;
        function rename(old_name: string, new_name: string): number;
        /**
         * Call this to drop caches, close plugins, terminate background threads, and
         * finalize any internal library testing.
         *
         * [func`shutdown]` is optional. If you don't call it, your platform will
         * clean up for you. The only negative consequences are that the leak checker
         * and the profiler will not work.
         *
         * You may call [func`INIT]` many times and [func`shutdown]` many times, but you
         * must not call [func`INIT]` after [func`shutdown]`. In other words, you cannot
         * stop and restart libvips.
         *
         * ::: seealso
         *     [func`profile_set]`, [func`leak_set]`.
         */
        function shutdown(): void;
        /**
         * Loops over `im,` generating it to a memory buffer attached to `im`. It is
         * used by vips to implement writing to a memory buffer.
         *
         * ::: seealso
         *     [method`Image`.sink], [method`Image`.get_tile_size],
         *     [ctor`Image`.new_memory].
         * @param im generate this image to memory
         * @returns 0 on success, or -1 on error.
         */
        function sink_memory(im: Image): number;
        /**
         * Test two lists for equality.
         * @param l1 a [struct@GLib.SList]
         * @param l2 another [struct@GLib.SList]
         * @returns `TRUE` if @l1 is equal to @l2. `FALSE` otherwise.
         */
        function slist_equal(l1: Uint8Array | string, l2: Uint8Array | string): boolean;
        /**
         * Remove all occurrences of an item from a list.
         * Returns the new head of the list.
         * @param list a [struct@GLib.SList]
         * @param fn function to call for each element.
         * @param a user data
         * @param b user data
         * @returns new head of @list
         */
        function slist_filter(list: Uint8Array | string, fn: SListMap2Fn, a?: any | null, b?: any | null): Uint8Array;
        /**
         * Fold over a slist, applying `fn` to each element.
         * @param list a [struct@GLib.SList]
         * @param start initial value for the accumulator
         * @param fn function to apply to each list element
         * @param a user data
         * @param b user data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function slist_fold2(
            list: Uint8Array | string,
            start: any | null,
            fn: SListFold2Fn,
            a?: any | null,
            b?: any | null,
        ): any | null;
        /**
         * Free a [struct`GLib`.SList] of things which need [func`GLib`.free]ing.
         * @param list a [struct@GLib.SList]
         */
        function slist_free_all(list: Uint8Array | string): void;
        /**
         * Map over a slist. _copy() the list in case the callback changes it.
         * @param list a [struct@GLib.SList]
         * @param fn function to apply to each list element
         * @param a user data
         * @param b user data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function slist_map2(list: Uint8Array | string, fn: SListMap2Fn, a?: any | null, b?: any | null): any | null;
        /**
         * Map backwards. We _reverse() rather than recurse and unwind to save stack.
         * @param list a [struct@GLib.SList]
         * @param fn function to apply to each list element
         * @param a user data
         * @param b user data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function slist_map2_rev(list: Uint8Array | string, fn: SListMap2Fn, a?: any | null, b?: any | null): any | null;
        /**
         * Map over a slist. _copy() the list in case the callback changes it.
         * @param list a [struct@GLib.SList]
         * @param fn function to apply to each list element
         * @param a user data
         * @param b user data
         * @param c user data
         * @param d user data
         * @returns `NULL` if @fn returns `NULL` for all arguments, otherwise the first non-`NULL` value from @fn.
         */
        function slist_map4(
            list: Uint8Array | string,
            fn: SListMap4Fn,
            a?: any | null,
            b?: any | null,
            c?: any | null,
            d?: any | null,
        ): any | null;
        /**
         * Start function for many images in. `a` is a pointer to
         * a `NULL`-terminated array of input images.
         *
         * ::: seealso
         *     [method`Image`.generate], [func`allocate_input_array]`
         * @param out image to generate
         * @param a user data
         * @param b user data
         */
        function start_many(out: Image, a?: any | null, b?: any | null): any | null;
        /**
         * Start function for one image in. Input image is `a`.
         *
         * ::: seealso
         *     [method`Image`.generate].
         * @param out image to generate
         * @param a user data
         * @param b user data
         */
        function start_one(out: Image, a?: any | null, b?: any | null): any | null;
        /**
         * Stop function for many images in. `a` is a pointer to
         * a `NULL`-terminated array of input images.
         *
         * ::: seealso
         *     [method`Image`.generate].
         * @param seq sequence value
         * @param a user data
         * @param b user data
         */
        function stop_many(seq?: any | null, a?: any | null, b?: any | null): number;
        /**
         * Stop function for one image in. Input image is `a`.
         *
         * ::: seealso
         *     [method`Image`.generate].
         * @param seq sequence value
         * @param a user data
         * @param b user data
         */
        function stop_one(seq?: any | null, a?: any | null, b?: any | null): number;
        /**
         * [func`GLib`.strdup] a string. When `object` is freed, the string will be freed for
         * you.  If `object` is `NULL`, you need to
         * free the memory yourself with [func`GLib`.free].
         *
         * This function cannot fail.
         *
         * ::: seealso
         *     [func`malloc]`.
         * @param object allocate memory local to this [class@Object], or `NULL`
         * @param str string to copy
         * @returns a pointer to the allocated memory
         */
        function strdup(object: Object | null, str: string): string;
        function strtod(str: string, out: number): number;
        /**
         * A newly created or reused thread will execute `func` with the
         * argument `data`.
         * @param domain a name for the thread (useful for debugging)
         * @param func a function to execute in the libvips threadset
         * @returns 0 on success, -1 on error.
         */
        function thread_execute(domain: string, func: GLib.Func): number;
        function thread_isvips(): boolean;
        /**
         * Free any thread-private data and flush any profiling information.
         *
         * This function needs to be called when a thread that has been using vips
         * exits. It is called for you by [func`shutdown]` and for any threads created
         * within the thread pool.
         *
         * You will need to call it from threads created in
         * other ways or there will be memory leaks. If you do not call it, vips
         * will generate a warning message.
         *
         * It may be called many times, and you can continue using vips after
         * calling it. Calling it too often will reduce performance.
         */
        function thread_shutdown(): void;
        /**
         * Allocate an area of memory aligned on a boundary specified
         * by `align` that will be tracked by [func`tracked_get_mem]`
         * and friends.
         *
         * If allocation fails, [func`tracked_aligned_alloc]` returns `NULL`
         * and sets an error message.
         *
         * You must only free the memory returned with [func`tracked_aligned_free]`.
         *
         * ::: seealso
         *     [func`tracked_malloc]`, [func`tracked_aligned_free]`, [func`malloc]`.
         * @param size number of bytes to allocate
         * @param align specifies the alignment
         * @returns a pointer to the allocated memory, or `NULL` on error.
         */
        function tracked_aligned_alloc(size: number, align: number): any | null;
        /**
         * Only use it to free memory that was
         * previously allocated with [func`tracked_aligned_alloc]`
         * with a `NULL` first argument.
         *
         * ::: seealso
         *     [func`tracked_aligned_alloc]`.
         * @param s memory to free
         */
        function tracked_aligned_free(s?: any | null): void;
        /**
         * Exactly as [`close()`](man:close(2)), but update the number of files currently open via
         * [func`tracked_get_files]`. This is used
         * by the vips operation cache to drop cache when the number of files
         * available is low.
         *
         * You must only close file descriptors opened with [func`tracked_open]`.
         *
         * ::: seealso
         *     [func`tracked_open]`, [func`tracked_get_files]`.
         * @param fd file to `close()`
         * @returns a file descriptor, or -1 on error.
         */
        function tracked_close(fd: number): number;
        /**
         * Only use it to free memory that was
         * previously allocated with [func`tracked_malloc]`
         * with a `NULL` first argument.
         *
         * ::: seealso
         *     [func`tracked_malloc]`.
         * @param s memory to free
         */
        function tracked_free(s?: any | null): void;
        /**
         * Returns the number of active allocations.
         * @returns the number of active allocations
         */
        function tracked_get_allocs(): number;
        /**
         * Returns the number of open files.
         * @returns the number of open files
         */
        function tracked_get_files(): number;
        /**
         * Returns the number of bytes currently allocated via [func`malloc]` and
         * friends. vips uses this figure to decide when to start dropping cache, see
         * [class`Operation]`.
         * @returns the number of currently allocated bytes
         */
        function tracked_get_mem(): number;
        /**
         * Returns the largest number of bytes simultaneously allocated via
         * [func`tracked_malloc]`. Handy for estimating max memory requirements for a
         * program.
         * @returns the largest number of currently allocated bytes
         */
        function tracked_get_mem_highwater(): number;
        /**
         * Allocate an area of memory that will be tracked by [func`tracked_get_mem]`
         * and friends.
         *
         * If allocation fails, [func`tracked_malloc]` returns `NULL` and
         * sets an error message.
         *
         * You must only free the memory returned with [func`tracked_free]`.
         *
         * ::: seealso
         *     [func`tracked_free]`, [func`malloc]`.
         * @param size number of bytes to allocate
         * @returns a pointer to the allocated memory, or `NULL` on error.
         */
        function tracked_malloc(size: number): any | null;
        /**
         * Exactly as [`open()`](man:open(2)), but the number of files currently open via
         * [func`tracked_open]` is available via [func`tracked_get_files]`. This is used
         * by the vips operation cache to drop cache when the number of files
         * available is low.
         *
         * You must only close the file descriptor with [func`tracked_close]`.
         *
         * `pathname` should be utf8.
         *
         * ::: seealso
         *     [func`tracked_close]`, [func`tracked_get_files]`.
         * @param pathname name of file to open
         * @param flags flags for `open()`
         * @param mode open mode
         * @returns a file descriptor, or -1 on error.
         */
        function tracked_open(pathname: string, flags: number, mode: number): number;
        function type_depth(type: GObject.GType): number;
        /**
         * Search below `basename,` return the [alias`GObject`.Type] of the class
         * whose name or `nickname` matches, or 0 for not found.
         * If `basename` is `NULL`, the whole of [class`Object]` is searched.
         *
         * This function uses a cache, so it should be quick.
         *
         * ::: seealso
         *     [func`class_find]`
         * @param basename name of base class
         * @param nickname search for a class with this nickname
         * @returns the [alias@GObject.Type] of the class, or 0 if the class is not found.
         */
        function type_find(basename: string, nickname: string): GObject.GType;
        /**
         * Get the pointer from an area. Don't touch count (area is static).
         * @param value get from this value
         * @returns The pointer held by @value.
         */
        function value_get_area(value: GObject.Value | any): [any | null, number];
        /**
         * Return the pointer to the array held by `value`.
         * Optionally return the other properties of the array in `n,` `type,`
         * `sizeof_type`.
         *
         * ::: seealso
         *     [func`value_set_array]`.
         * @param value [struct@GObject.Value] to get from
         * @returns The array address.
         */
        function value_get_array(value: GObject.Value | any): [any | null, number, GObject.GType | null, number];
        /**
         * Return the start of the array of doubles held by `value`.
         * optionally return the number of elements in `n`.
         *
         * ::: seealso
         *     [ctor`ArrayDouble`.new].
         * @param value [struct@GObject.Value] to get from
         * @returns The array address.
         */
        function value_get_array_double(value: GObject.Value | any): number[];
        /**
         * Return the start of the array of images held by `value`.
         * optionally return the number of elements in `n`.
         *
         * ::: seealso
         *     [func`value_set_array_image]`.
         * @param value [struct@GObject.Value] to get from
         * @returns The array address.
         */
        function value_get_array_image(value: GObject.Value | any): Image[];
        /**
         * Return the start of the array of ints held by `value`.
         * optionally return the number of elements in `n`.
         *
         * ::: seealso
         *     [ctor`ArrayInt`.new].
         * @param value [struct@GObject.Value] to get from
         * @returns The array address.
         */
        function value_get_array_int(value: GObject.Value | any): number[];
        /**
         * Returns the data pointer from a blob. Optionally returns the length too.
         *
         * blobs are things like ICC profiles or EXIF data. They are relocatable, and
         * are saved to VIPS files for you coded as base64 inside the XML. They are
         * copied by copying reference-counted pointers.
         *
         * ::: seealso
         *     [func`value_set_blob]`
         * @param value GValue to set
         * @returns The pointer held by @value.
         */
        function value_get_blob(value: GObject.Value | any): Uint8Array;
        /**
         * Get the C string held internally by the [struct`GObject`.Value].
         * @param value [struct@GObject.Value] to get from
         * @returns The C string held by @value.
         */
        function value_get_ref_string(value: GObject.Value | any): [string, number];
        /**
         * Get the C string held internally by the GValue.
         * @param value GValue to get from
         * @returns The C string held by @value.
         */
        function value_get_save_string(value: GObject.Value | any): string;
        function value_is_null(psoec: GObject.ParamSpec, value: GObject.Value | any): boolean;
        /**
         * Set value to be a ref-counted area of memory with a free function.
         * @param value set this value
         * @param free_fn data will be freed with this function
         */
        function value_set_area(value: GObject.Value | any, free_fn?: CallbackFn | null): void;
        /**
         * Set `value` to be an array of things.
         *
         * This allocates memory but does not
         * initialise the contents: get the pointer and write instead.
         * @param n number of elements
         * @param type the type of each element
         * @param sizeof_type the sizeof each element
         */
        function value_set_array(n: number, type: GObject.GType, sizeof_type: number): unknown;
        /**
         * Set `value` to hold a copy of `array`. Pass in the array length in `n`.
         *
         * ::: seealso
         *     [method`ArrayDouble`.get].
         * @param value [struct@GObject.Value] to get from
         * @param array array of doubles
         */
        function value_set_array_double(value: GObject.Value | any, array?: number[] | null): void;
        /**
         * Set `value` to hold an array of images. Pass in the array length in `n`.
         *
         * ::: seealso
         *     [method`ArrayImage`.get].
         * @param value [struct@GObject.Value] to get from
         * @param n the number of elements
         */
        function value_set_array_image(value: GObject.Value | any, n: number): void;
        /**
         * Set `value` to hold a copy of `array`. Pass in the array length in `n`.
         *
         * ::: seealso
         *     [method`ArrayInt`.get].
         * @param value [struct@GObject.Value] to get from
         * @param array array of ints
         */
        function value_set_array_int(value: GObject.Value | any, array?: number[] | null): void;
        /**
         * Set `value` to hold an array of [class`GObject`.Object]. Pass in the array length in `n`.
         *
         * ::: seealso
         *     [func`value_get_array_object]`.
         * @param n the number of elements
         */
        function value_set_array_object(n: number): unknown;
        /**
         * Sets `value` to hold a `data`. When `value` is freed, `data` will be
         * freed with `free_fn`. `value` also holds a note of the size of the memory
         * area.
         *
         * blobs are things like ICC profiles or EXIF data. They are relocatable, and
         * are saved to VIPS files for you coded as base64 inside the XML. They are
         * copied by copying reference-counted pointers.
         *
         * ::: seealso
         *     [func`value_get_blob]`
         * @param free_fn free function for @data
         * @param data pointer to area of memory
         */
        function value_set_blob(free_fn: CallbackFn | null, data: Uint8Array | string): unknown;
        /**
         * Just like [func`value_set_blob]`, but when
         * `value` is freed, `data` will be
         * freed with [func`GLib`.free].
         *
         * This can be easier to call for language bindings.
         *
         * ::: seealso
         *     [func`value_set_blob]`
         * @param value GValue to set
         * @param data pointer to area of memory
         */
        function value_set_blob_free(value: GObject.Value | any, data: Uint8Array | string): void;
        /**
         * Copies the C string `str` into `value`.
         *
         * vips_ref_string are immutable C strings that are copied between images by
         * copying reference-counted pointers, making them much more efficient than
         * regular [struct`GObject`.Value] strings.
         *
         * `str` should be a valid utf-8 string.
         * @param str C string to copy into the GValue
         */
        function value_set_ref_string(str: string): unknown;
        /**
         * Copies the C string into `value`.
         *
         * `str` should be a valid utf-8 string.
         * @param str C string to copy into the GValue
         */
        function value_set_save_string(str: string): unknown;
        /**
         * Takes a bitfield of targets to disable on the runtime platform.
         * Handy for testing and benchmarking purposes.
         *
         * This can also be set using the `VIPS_VECTOR` environment variable.
         * @param disabled_targets A bitfield of targets to disable at runtime.
         */
        function vector_disable_targets(disabled_targets: number): void;
        /**
         * Gets a bitfield of builtin targets that libvips was built with.
         * @returns a bitfield of builtin targets.
         */
        function vector_get_builtin_targets(): number;
        /**
         * Gets a bitfield of enabled targets that are supported on this CPU. The
         * targets returned may change after calling [func`vector_disable_targets]`.
         * @returns a bitfield of supported CPU targets.
         */
        function vector_get_supported_targets(): number;
        function vector_isenabled(): boolean;
        function vector_set_enabled(enabled: boolean): void;
        /**
         * Generates a human-readable ASCII string descriptor for a specific target.
         * @param target A specific target to describe.
         * @returns a string describing the target.
         */
        function vector_target_name(target: number): string;
        /**
         * Get the major, minor or micro library version, with `flag` values 0, 1 and
         * 2.
         *
         * Get the ABI current, revision and age (as used by Meson) with `flag`
         * values 3, 4, 5.
         * @param flag which field of the version to get
         * @returns library version number
         */
        function version(flag: number): number;
        /**
         * Get the VIPS version as a static string, including a build date and time.
         * Do not free.
         * @returns a static version string
         */
        function version_string(): string;
        interface ArgumentClassMapFn {
            (
                object_class: typeof Object,
                pspec: GObject.ParamSpec,
                argument_class: ArgumentClass,
                a?: any | null,
                b?: any | null,
            ): any | null;
        }
        interface ArgumentMapFn {
            (
                object: Object,
                pspec: GObject.ParamSpec,
                argument_class: ArgumentClass,
                argument_instance: ArgumentInstance,
                a?: any | null,
                b?: any | null,
            ): any | null;
        }
        interface CallbackFn {
            (a?: any | null, b?: any | null): number;
        }
        interface ClassMapFn {
            (cls: typeof Object, a?: any | null): any | null;
        }
        interface GenerateFn {
            (out: Region, seq: any | null, a: any | null, b: any | null, stop: boolean): number;
        }
        interface ImageMapFn {
            (image: Image, name: string, value: GObject.Value | any, a?: any | null): any | null;
        }
        interface InterpolateMethod {
            (interpolate: Interpolate, out: any | null, _in: Region, x: number, y: number): void;
        }
        interface ObjectSetArguments {
            (object: Object, a?: any | null, b?: any | null): any | null;
        }
        interface OperationBuildFn {
            (object: Object): boolean;
        }
        interface RegionWrite {
            (region: Region, area: Rect, a?: any | null): number;
        }
        interface SListFold2Fn {
            (item?: any | null, a?: any | null, b?: any | null, c?: any | null): any | null;
        }
        interface SListMap2Fn {
            (item?: any | null, a?: any | null, b?: any | null): any | null;
        }
        interface SListMap4Fn {
            (item?: any | null, a?: any | null, b?: any | null, c?: any | null, d?: any | null): any | null;
        }
        interface SinkNotify {
            (im: Image, rect: Rect, a?: any | null): void;
        }
        interface StartFn {
            (out: Image, a?: any | null, b?: any | null): any | null;
        }
        interface StopFn {
            (seq?: any | null, a?: any | null, b?: any | null): number;
        }
        interface ThreadpoolAllocateFn {
            (state: ThreadState, a: any | null, stop: boolean): number;
        }
        interface ThreadpoolProgressFn {
            (a?: any | null): number;
        }
        interface ThreadpoolWorkFn {
            (state: ThreadState, a?: any | null): number;
        }
        interface TypeMap2Fn {
            (type: GObject.GType, a?: any | null, b?: any | null): any | null;
        }
        interface TypeMapFn {
            (type: GObject.GType, a?: any | null): any | null;
        }
        /**
         * Flags we associate with each object argument.
         *
         * Have separate input & output flags. Both set is an error; neither set is OK.
         *
         * Input gobjects are automatically reffed, output gobjects automatically ref
         * us. We also automatically watch for "destroy" and unlink.
         *
         * [flags`Vips`.ArgumentFlags.SET_ALWAYS] is handy for arguments which are set from C. For
         * example, [property`Image:`width] is a property that gives access to the Xsize
         * member of struct _VipsImage. We default its 'assigned' to `TRUE`
         * since the field is always set directly by C.
         *
         * [flags`Vips`.ArgumentFlags.DEPRECATED] arguments are not shown in help text, are not
         * looked for if required, are not checked for "have-been-set". You can
         * deprecate a required argument, but you must obviously add a new required
         * argument if you do.
         *
         * Input args with [flags`Vips`.ArgumentFlags.MODIFY] will be modified by the operation.
         * This is used for things like the in-place drawing operations.
         *
         * [flags`Vips`.ArgumentFlags.NON_HASHABLE] stops the argument being used in hash and
         * equality tests. It's useful for arguments like `revalidate` which
         * control the behaviour of the operator cache.
         */

        /**
         * Flags we associate with each object argument.
         *
         * Have separate input & output flags. Both set is an error; neither set is OK.
         *
         * Input gobjects are automatically reffed, output gobjects automatically ref
         * us. We also automatically watch for "destroy" and unlink.
         *
         * [flags`Vips`.ArgumentFlags.SET_ALWAYS] is handy for arguments which are set from C. For
         * example, [property`Image:`width] is a property that gives access to the Xsize
         * member of struct _VipsImage. We default its 'assigned' to `TRUE`
         * since the field is always set directly by C.
         *
         * [flags`Vips`.ArgumentFlags.DEPRECATED] arguments are not shown in help text, are not
         * looked for if required, are not checked for "have-been-set". You can
         * deprecate a required argument, but you must obviously add a new required
         * argument if you do.
         *
         * Input args with [flags`Vips`.ArgumentFlags.MODIFY] will be modified by the operation.
         * This is used for things like the in-place drawing operations.
         *
         * [flags`Vips`.ArgumentFlags.NON_HASHABLE] stops the argument being used in hash and
         * equality tests. It's useful for arguments like `revalidate` which
         * control the behaviour of the operator cache.
         */
        export namespace ArgumentFlags {
            export const $gtype: GObject.GType<ArgumentFlags>;
        }

        enum ArgumentFlags {
            /**
             * no flags
             */
            NONE,
            /**
             * must be set in the constructor
             */
            REQUIRED,
            /**
             * can only be set in the constructor
             */
            CONSTRUCT,
            /**
             * can only be set once
             */
            SET_ONCE,
            /**
             * don't do use-before-set checks
             */
            SET_ALWAYS,
            /**
             * is an input argument (one we depend on)
             */
            INPUT,
            /**
             * is an output argument (depends on us)
             */
            OUTPUT,
            /**
             * just there for back-compat, hide
             */
            DEPRECATED,
            /**
             * the input argument will be modified
             */
            MODIFY,
            /**
             * the argument is non-hashable
             */
            NON_HASHABLE,
        }
        /**
         * The set of coding types supported by a saver.
         *
         * ::: seealso
         *     [enum`Coding]`.
         */

        /**
         * The set of coding types supported by a saver.
         *
         * ::: seealso
         *     [enum`Coding]`.
         */
        export namespace ForeignCoding {
            export const $gtype: GObject.GType<ForeignCoding>;
        }

        enum ForeignCoding {
            /**
             * saver supports [enum`Vips`.Coding.NONE]
             */
            NONE,
            /**
             * saver supports [enum`Vips`.Coding.LABQ]
             */
            LABQ,
            /**
             * saver supports [enum`Vips`.Coding.RAD]
             */
            RAD,
            /**
             * saver supports all coding types
             */
            ALL,
        }
        /**
         * Some hints about the image loader.
         *
         * [flags`Vips`.ForeignFlags.PARTIAL] means that the image can be read directly from the
         * file without needing to be unpacked to a temporary image first.
         *
         * [flags`Vips`.ForeignFlags.SEQUENTIAL] means that the loader supports lazy reading, but
         * only top-to-bottom (sequential) access. Formats like PNG can read sets of
         * scanlines, for example, but only in order.
         *
         * If neither PARTIAL or SEQUENTIAL is set, the loader only supports whole
         * image read. Setting both PARTIAL and SEQUENTIAL is an error.
         *
         * [flags`Vips`.ForeignFlags.BIGENDIAN] means that image pixels are most-significant byte
         * first. Depending on the native byte order of the host machine, you may
         * need to swap bytes. See [method`Image`.copy].
         */

        /**
         * Some hints about the image loader.
         *
         * [flags`Vips`.ForeignFlags.PARTIAL] means that the image can be read directly from the
         * file without needing to be unpacked to a temporary image first.
         *
         * [flags`Vips`.ForeignFlags.SEQUENTIAL] means that the loader supports lazy reading, but
         * only top-to-bottom (sequential) access. Formats like PNG can read sets of
         * scanlines, for example, but only in order.
         *
         * If neither PARTIAL or SEQUENTIAL is set, the loader only supports whole
         * image read. Setting both PARTIAL and SEQUENTIAL is an error.
         *
         * [flags`Vips`.ForeignFlags.BIGENDIAN] means that image pixels are most-significant byte
         * first. Depending on the native byte order of the host machine, you may
         * need to swap bytes. See [method`Image`.copy].
         */
        export namespace ForeignFlags {
            export const $gtype: GObject.GType<ForeignFlags>;
        }

        enum ForeignFlags {
            /**
             * no flags set
             */
            NONE,
            /**
             * the image may be read lazilly
             */
            PARTIAL,
            /**
             * image pixels are most-significant byte first
             */
            BIGENDIAN,
            /**
             * top-to-bottom lazy reading
             */
            SEQUENTIAL,
            ALL,
        }
        /**
         * Which metadata to retain.
         */

        /**
         * Which metadata to retain.
         */
        export namespace ForeignKeep {
            export const $gtype: GObject.GType<ForeignKeep>;
        }

        enum ForeignKeep {
            /**
             * don't attach metadata
             */
            NONE,
            /**
             * keep Exif metadata
             */
            EXIF,
            /**
             * keep XMP metadata
             */
            XMP,
            /**
             * keep IPTC metadata
             */
            IPTC,
            /**
             * keep ICC metadata
             */
            ICC,
            /**
             * keep other metadata (e.g. PNG comments and some TIFF tags)
             */
            OTHER,
            /**
             * keep all metadata
             */
            ALL,
        }
        /**
         * http://www.w3.org/TR/PNG-Filters.html
         * The values mirror those of png.h in libpng.
         */

        /**
         * http://www.w3.org/TR/PNG-Filters.html
         * The values mirror those of png.h in libpng.
         */
        export namespace ForeignPngFilter {
            export const $gtype: GObject.GType<ForeignPngFilter>;
        }

        enum ForeignPngFilter {
            /**
             * no filtering
             */
            NONE,
            /**
             * difference to the left
             */
            SUB,
            /**
             * difference up
             */
            UP,
            /**
             * average of left and up
             */
            AVG,
            /**
             * pick best neighbor predictor automatically
             */
            PAETH,
            /**
             * adaptive
             */
            ALL,
        }
        /**
         * The set of image types supported by a saver.
         *
         * ::: seealso
         *     [class`ForeignSave]`.
         */

        /**
         * The set of image types supported by a saver.
         *
         * ::: seealso
         *     [class`ForeignSave]`.
         */
        export namespace ForeignSaveable {
            export const $gtype: GObject.GType<ForeignSaveable>;
        }

        enum ForeignSaveable {
            /**
             * saver supports everything (eg. TIFF)
             */
            ANY,
            /**
             * 1 band
             */
            MONO,
            /**
             * 3 bands
             */
            RGB,
            /**
             * 4 bands
             */
            CMYK,
            /**
             * an extra band
             */
            ALPHA,
            ALL,
        }
        /**
         * Flags we associate with an operation.
         *
         * [flags`Vips`.OperationFlags.SEQUENTIAL] means that the operation works like
         * [method`Image`.conv]: it can process images top-to-bottom with only small
         * non-local references.
         *
         * Every scan-line must be requested, you are not allowed to skip
         * ahead, but as a special case, the very first request can be for a region
         * not at the top of the image. In this case, the first part of the image will
         * be read and discarded
         *
         * Every scan-line must be requested, you are not allowed to skip
         * ahead, but as a special case, the very first request can be for a region
         * not at the top of the image. In this case, the first part of the image will
         * be read and discarded
         *
         * [flags`Vips`.OperationFlags.NOCACHE] means that the operation must not be cached by
         * vips.
         *
         * [flags`Vips`.OperationFlags.DEPRECATED] means this is an old operation kept in vips for
         * compatibility only and should be hidden from users.
         *
         * [flags`Vips`.OperationFlags.UNTRUSTED] means the operation depends on external libraries
         * which have not been hardened against attack. It should probably not be used
         * on untrusted input. Use [func`block_untrusted_set]` to block all
         * untrusted operations.
         *
         * [flags`Vips`.OperationFlags.BLOCKED] means the operation is prevented from executing. Use
         * [func`Operation`.block_set] to enable and disable groups of operations.
         *
         * [flags`Vips`.OperationFlags.REVALIDATE] force the operation to run, updating the cache
         * with the new value. This is used by eg. VipsForeignLoad to implement the
         * "revalidate" argument.
         */

        /**
         * Flags we associate with an operation.
         *
         * [flags`Vips`.OperationFlags.SEQUENTIAL] means that the operation works like
         * [method`Image`.conv]: it can process images top-to-bottom with only small
         * non-local references.
         *
         * Every scan-line must be requested, you are not allowed to skip
         * ahead, but as a special case, the very first request can be for a region
         * not at the top of the image. In this case, the first part of the image will
         * be read and discarded
         *
         * Every scan-line must be requested, you are not allowed to skip
         * ahead, but as a special case, the very first request can be for a region
         * not at the top of the image. In this case, the first part of the image will
         * be read and discarded
         *
         * [flags`Vips`.OperationFlags.NOCACHE] means that the operation must not be cached by
         * vips.
         *
         * [flags`Vips`.OperationFlags.DEPRECATED] means this is an old operation kept in vips for
         * compatibility only and should be hidden from users.
         *
         * [flags`Vips`.OperationFlags.UNTRUSTED] means the operation depends on external libraries
         * which have not been hardened against attack. It should probably not be used
         * on untrusted input. Use [func`block_untrusted_set]` to block all
         * untrusted operations.
         *
         * [flags`Vips`.OperationFlags.BLOCKED] means the operation is prevented from executing. Use
         * [func`Operation`.block_set] to enable and disable groups of operations.
         *
         * [flags`Vips`.OperationFlags.REVALIDATE] force the operation to run, updating the cache
         * with the new value. This is used by eg. VipsForeignLoad to implement the
         * "revalidate" argument.
         */
        export namespace OperationFlags {
            export const $gtype: GObject.GType<OperationFlags>;
        }

        enum OperationFlags {
            /**
             * no flags
             */
            NONE,
            /**
             * can work sequentially with a small buffer
             */
            SEQUENTIAL,
            SEQUENTIAL_UNBUFFERED,
            /**
             * must not be cached
             */
            NOCACHE,
            /**
             * a compatibility thing
             */
            DEPRECATED,
            /**
             * not hardened for untrusted input
             */
            UNTRUSTED,
            /**
             * prevent this operation from running
             */
            BLOCKED,
            /**
             * force the operation to run
             */
            REVALIDATE,
        }
        namespace Connection {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                'notify::descriptor': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {
                descriptor: number;
                filename: string;
            }
        }

        /**
         * An abstract base class representing a source or sink of bytes.
         *
         * It can be connected to a network socket, for example, or perhaps
         * a Node.js stream, or to an area of memory. This allows it to support
         * operations like JPEG loading, see for example [ctor`Image`.jpegload_source].
         *
         * Subclass to add other input sources. Use [class`SourceCustom]` and
         * [class`TargetCustom]` to make a source or target with action signals.
         * These classes provide action signals such as:
         *
         * - [signal`SourceCustom:`:read] for reading data from a custom source.
         * - [signal`SourceCustom:`:seek] for seeking within a data stream.
         * - [signal`TargetCustom:`:write] for writing data to a custom target.
         */
        abstract class Connection extends Object {
            static $gtype: GObject.GType<Connection>;

            // Properties

            get descriptor(): number;
            set descriptor(val: number);
            get filename(): string;
            set filename(val: string);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Connection.SignalSignatures;

            // Fields

            parent_object: Object;

            // Constructors

            constructor(properties?: Partial<Connection.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            // Signals

            connect<K extends keyof Connection.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Connection.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Connection.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Connection.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Connection.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Connection.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Methods

            nick(): string;
        }

        namespace Foreign {
            // Signal signatures
            interface SignalSignatures extends Operation.SignalSignatures {
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Operation.ConstructorProps {}
        }

        /**
         * An abstract base class to load and save images in a variety of formats.
         *
         * ## Load and save
         *
         * You can load and save from and to files, memory areas, and the libvips IO
         * abstractions, [class`Source]` and [class`Target]`.
         *
         * Use [func`Foreign`.find_load] [func`Foreign`.find_load_buffer] and
         * [func`Foreign`.find_load_source] to find a loader for an object. Use
         * [func`Foreign`.find_save], [func`Foreign`.find_save_buffer] and
         * [func`Foreign`.find_save_target] to find a saver for a format. You can then
         * run these operations using [func`call]` and friends to perform the load or
         * save.
         *
         * [method`Image`.write_to_file] and [ctor`Image`.new_from_file] and friends use
         * these functions to automate file load and save.
         *
         * You can also invoke the operations directly, for example:
         *
         * ```c
         * vips_tiffsave(my_image, "frank.anything",
         *     "compression", VIPS_FOREIGN_TIFF_COMPRESSION_JPEG,
         *     NULL);
         * ```
         *
         * ## Image metadata
         *
         * All loaders attach all image metadata as libvips properties on load.
         *
         * You can change metadata with [method`Image`.set_int] and friends.
         *
         * During save, you can use `keep` to specify which metadata to retain,
         * defaults to all, see [flags`ForeignKeep]`. Setting `profile` will
         * automatically keep the ICC profile.
         *
         * ## Many page images
         *
         * By default, libvips will only load the first page of many page or animated
         * images. Use `page` and `n` to set the start page and the number of pages to
         * load. Set `n` to -1 to load all pages.
         *
         * Many page images are loaded as a tall, thin strip of pages.
         *
         * Use [method`Image`.get_page_height] and [method`Image`.get_n_pages] to find
         * the page height and number of pages of a loaded image.
         *
         * Use `page_height` to set the page height for image save.
         *
         * ## Alpha save
         *
         * Not all image formats support alpha. If you try to save an image with an
         * alpha channel to a format that does not support it, the alpha will be
         * automatically flattened out. Use `background` (default 0) to set the colour
         * that alpha should be flattened against.
         *
         * ## Adding new formats
         *
         * To add support for a new file format to vips, simply define a new subclass
         * of [class`ForeignLoad]` or [class`ForeignSave]`.
         *
         * If you define a new operation which is a subclass of [class`Foreign]`,
         * support for it automatically appears in all libvips user-interfaces. It
         * will also be transparently supported by [ctor`Image`.new_from_file] and
         * friends.
         */
        abstract class Foreign extends Operation {
            static $gtype: GObject.GType<Foreign>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Foreign.SignalSignatures;

            // Fields

            parent_object: Operation;

            // Constructors

            constructor(properties?: Partial<Foreign.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            // Signals

            connect<K extends keyof Foreign.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Foreign.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Foreign.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Foreign.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Foreign.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Foreign.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            /**
             * Searches for an operation you could use to load `filename`. Any trailing
             * options on `filename` are stripped and ignored.
             *
             * ::: seealso
             *     [func`Foreign`.find_load_buffer], [ctor`Image`.new_from_file].
             * @param filename file to find a loader for
             */
            static find_load(filename: string): string;
            /**
             * Searches for an operation you could use to load a memory buffer. To see the
             * range of buffer loaders supported by your vips, try something like:
             *
             * 	vips -l | grep load_buffer
             *
             * ::: seealso
             *     [ctor`Image`.new_from_buffer].
             * @param data start of memory buffer
             */
            static find_load_buffer(data: Uint8Array | string): string;
            /**
             * Searches for an operation you could use to load a source. To see the
             * range of source loaders supported by your vips, try something like:
             *
             * 	vips -l | grep load_source
             *
             * ::: seealso
             *     [ctor`Image`.new_from_source].
             * @param source source to load from
             */
            static find_load_source(source: Source): string;
            /**
             * Searches for an operation you could use to write to `filename`.
             * Any trailing options on `filename` are stripped and ignored.
             *
             * ::: seealso
             *     [func`Foreign`.find_save_buffer], [method`Image`.write_to_file].
             * @param filename name to find a saver for
             */
            static find_save(filename: string): string | null;
            /**
             * Searches for an operation you could use to write to a buffer in `suffix`
             * format.
             *
             * ::: seealso
             *     [method`Image`.write_to_buffer].
             * @param suffix name to find a saver for
             */
            static find_save_buffer(suffix: string): string | null;
            /**
             * Searches for an operation you could use to write to a target in `suffix`
             * format.
             *
             * ::: seealso
             *     [method`Image`.write_to_buffer].
             * @param suffix format to find a saver for
             */
            static find_save_target(suffix: string): string | null;
            /**
             * Get a `NULL`-terminated array listing all the supported suffixes.
             *
             * This is not the same as all the supported file types, since libvips
             * detects image format for load by testing the first few bytes.
             *
             * Use [func`Foreign`.find_load] to detect type for a specific file.
             *
             * Free the return result with [func`GLib`.strfreev].
             */
            static get_suffixes(): string[];
            /**
             * Return `TRUE` if `filename` can be loaded by `loader`. `loader` is something
             * like "tiffload" or "VipsForeignLoadTiff".
             * @param loader name of loader to use for test
             * @param filename file to test
             */
            static is_a(loader: string, filename: string): boolean;
            /**
             * Return `TRUE` if `data` can be loaded by `loader`. `loader` is something
             * like "tiffload_buffer" or "VipsForeignLoadTiffBuffer".
             * @param loader name of loader to use for test
             * @param data pointer to the buffer to test
             */
            static is_a_buffer(loader: string, data: Uint8Array | string): boolean;
            /**
             * Return `TRUE` if `source` can be loaded by `loader`. `loader` is something
             * like "tiffload_source" or "VipsForeignLoadTiffSource".
             * @param loader name of loader to use for test
             * @param source source to test
             */
            static is_a_source(loader: string, source: Source): boolean;
            /**
             * Apply a function to every [class`Foreign]` that VIPS knows about. Foreigns
             * are presented to the function in priority order.
             *
             * Like all VIPS map functions, if `fn` returns `NULL`, iteration continues. If
             * it returns non-`NULL`, iteration terminates and that value is returned. The
             * map function returns `NULL` if all calls return `NULL`.
             *
             * ::: seealso
             *     [func`slist_map2`].
             * @param base base class to search below (eg. "VipsForeignLoad")
             * @param fn function to apply to each [class@Foreign]
             * @param a user data
             * @param b user data
             */
            static map(base: string, fn: SListMap2Fn, a?: any | null, b?: any | null): any | null;
        }

        namespace ForeignLoad {
            // Signal signatures
            interface SignalSignatures extends Foreign.SignalSignatures {
                'notify::access': (pspec: GObject.ParamSpec) => void;
                'notify::disc': (pspec: GObject.ParamSpec) => void;
                'notify::fail': (pspec: GObject.ParamSpec) => void;
                'notify::fail-on': (pspec: GObject.ParamSpec) => void;
                'notify::flags': (pspec: GObject.ParamSpec) => void;
                'notify::memory': (pspec: GObject.ParamSpec) => void;
                'notify::out': (pspec: GObject.ParamSpec) => void;
                'notify::revalidate': (pspec: GObject.ParamSpec) => void;
                'notify::sequential': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Foreign.ConstructorProps {
                access: Access;
                disc: boolean;
                fail: boolean;
                fail_on: FailOn;
                failOn: FailOn;
                flags: ForeignFlags;
                memory: boolean;
                out: Image;
                revalidate: boolean;
                sequential: boolean;
            }
        }

        /**
         * An abstract base class to load images in a variety of formats.
         *
         * ## Writing a new loader
         *
         * Add a new loader to libvips by subclassing [class`ForeignLoad]`. Subclasses
         * need to implement at least [vfunc`ForeignLoad`.header].
         *
         * [vfunc`ForeignLoad`.header] must set at least the header fields of `out`.
         * [vfunc`ForeignLoad`.load], if defined, must load the pixels to `real`.
         *
         * The suffix list is used to select a format to save a file in, and to pick a
         * loader if you don't define [func`Foreign`.is_a].
         *
         * You should also define [property`Object:`nickname] and
         * [property`Object:`description] in [class`Object]`.
         *
         * As a complete example, here's code for a PNG loader, minus the actual
         * calls to libpng.
         *
         * ```c
         * typedef struct _VipsForeignLoadPng {
         *     VipsForeignLoad parent_object;
         *
         *     char *filename;
         * } VipsForeignLoadPng;
         *
         * typedef VipsForeignLoadClass VipsForeignLoadPngClass;
         *
         * G_DEFINE_TYPE(VipsForeignLoadPng, vips_foreign_load_png,
         *     VIPS_TYPE_FOREIGN_LOAD);
         *
         * static VipsForeignFlags
         * vips_foreign_load_png_get_flags_filename(const char *filename)
         * {
         *     VipsForeignFlags flags;
         *
         *     flags = 0;
         *     if (vips__png_isinterlaced(filename))
         *          flags = VIPS_FOREIGN_PARTIAL;
         *     else
         *          flags = VIPS_FOREIGN_SEQUENTIAL;
         *
         *     return flags;
         * }
         *
         * static VipsForeignFlags
         * vips_foreign_load_png_get_flags(VipsForeignLoad *load)
         * {
         *   VipsForeignLoadPng *png = (VipsForeignLoadPng *) load;
         *
         *   return vips_foreign_load_png_get_flags_filename(png->filename);
         * }
         *
         * static int
         * vips_foreign_load_png_header(VipsForeignLoad *load)
         * {
         *     VipsForeignLoadPng *png = (VipsForeignLoadPng *) load;
         *
         *     if (vips__png_header(png->filename, load->out))
         *         return -1;
         *
         *     return 0;
         * }
         *
         * static int
         * vips_foreign_load_png_load(VipsForeignLoad *load)
         * {
         *     VipsForeignLoadPng *png = (VipsForeignLoadPng *) load;
         *
         *     if (vips__png_read(png->filename, load->real))
         *         return -1;
         *
         *     return 0;
         * }
         *
         * static void
         * vips_foreign_load_png_class_init(VipsForeignLoadPngClass *class)
         * {
         *     GObjectClass *gobject_class = G_OBJECT_CLASS(class);
         *     VipsObjectClass *object_class = (VipsObjectClass *) class;
         *     VipsForeignClass *foreign_class = (VipsForeignClass *) class;
         *     VipsForeignLoadClass *load_class = (VipsForeignLoadClass *) class;
         *
         *     gobject_class->set_property = vips_object_set_property;
         *     gobject_class->get_property = vips_object_get_property;
         *
         *     object_class->nickname = "pngload";
         *     object_class->description = _("load png from file");
         *
         *     foreign_class->suffs = vips__png_suffs;
         *
         *     load_class->is_a = vips__png_ispng;
         *     load_class->get_flags_filename =
         *         vips_foreign_load_png_get_flags_filename;
         *     load_class->get_flags = vips_foreign_load_png_get_flags;
         *     load_class->header = vips_foreign_load_png_header;
         *     load_class->load = vips_foreign_load_png_load;
         *
         *     VIPS_ARG_STRING(class, "filename", 1,
         *         _("Filename"),
         *         _("Filename to load from"),
         *         VIPS_ARGUMENT_REQUIRED_INPUT,
         *         G_STRUCT_OFFSET(VipsForeignLoadPng, filename),
         *         NULL);
         * }
         *
         * static void
         * vips_foreign_load_png_init(VipsForeignLoadPng *png)
         * {
         * }
         * ```
         */
        abstract class ForeignLoad extends Foreign {
            static $gtype: GObject.GType<ForeignLoad>;

            // Properties

            get access(): Access;
            set access(val: Access);
            get disc(): boolean;
            set disc(val: boolean);
            get fail(): boolean;
            set fail(val: boolean);
            get fail_on(): FailOn;
            set fail_on(val: FailOn);
            get failOn(): FailOn;
            set failOn(val: FailOn);
            get flags(): ForeignFlags;
            set flags(val: ForeignFlags);
            get memory(): boolean;
            set memory(val: boolean);
            get out(): Image;
            set out(val: Image);
            get revalidate(): boolean;
            set revalidate(val: boolean);
            get sequential(): boolean;
            set sequential(val: boolean);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: ForeignLoad.SignalSignatures;

            // Fields

            parent_object: Foreign;
            real: Image;
            nocache: boolean;
            error: boolean;

            // Constructors

            constructor(properties?: Partial<ForeignLoad.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            // Signals

            connect<K extends keyof ForeignLoad.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ForeignLoad.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof ForeignLoad.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ForeignLoad.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof ForeignLoad.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<ForeignLoad.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Virtual methods

            vfunc_get_flags(): ForeignFlags;
            // Conflicted with Vips.Operation.vfunc_get_flags
            vfunc_get_flags(...args: never[]): any;
            vfunc_header(): number;
            vfunc_load(): number;
        }

        namespace ForeignSave {
            // Signal signatures
            interface SignalSignatures extends Foreign.SignalSignatures {
                'notify::background': (pspec: GObject.ParamSpec) => void;
                'notify::in': (pspec: GObject.ParamSpec) => void;
                'notify::keep': (pspec: GObject.ParamSpec) => void;
                'notify::page-height': (pspec: GObject.ParamSpec) => void;
                'notify::profile': (pspec: GObject.ParamSpec) => void;
                'notify::strip': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Foreign.ConstructorProps {
                background: ArrayDouble;
                in: Image;
                keep: ForeignKeep;
                page_height: number;
                pageHeight: number;
                profile: string;
                strip: boolean;
            }
        }

        /**
         * An abstract base class to save images in a variety of formats.
         *
         * ## Writing a new saver
         *
         * Call your saver in the class' [vfunc`Object`.build] method after chaining up.
         * The prepared image should be ready for you to save in `ready`.
         *
         * As a complete example, here's the code for the CSV saver, minus the calls
         * to the actual save routines.
         *
         * ```c
         * typedef struct _VipsForeignSaveCsv {
         *     VipsForeignSave parent_object;
         *
         *     char *filename;
         *     const char *separator;
         * } VipsForeignSaveCsv;
         *
         * typedef VipsForeignSaveClass VipsForeignSaveCsvClass;
         *
         * G_DEFINE_TYPE(VipsForeignSaveCsv, vips_foreign_save_csv,
         *   VIPS_TYPE_FOREIGN_SAVE);
         *
         * static int
         * vips_foreign_save_csv_build(VipsObject *object)
         * {
         *     VipsForeignSave *save = (VipsForeignSave *) object;
         *     VipsForeignSaveCsv *csv = (VipsForeignSaveCsv *) object;
         *
         *     if (VIPS_OBJECT_CLASS(vips_foreign_save_csv_parent_class)
         *             ->build(object))
         *         return -1;
         *
         *     if (vips__csv_write(save->ready, csv->filename, csv->separator))
         *   	  return -1;
         *
         *     return 0;
         * }
         *
         * static void
         * vips_foreign_save_csv_class_init(VipsForeignSaveCsvClass *class)
         * {
         *     GObjectClass *gobject_class = G_OBJECT_CLASS(class);
         *     VipsObjectClass *object_class = (VipsObjectClass *) class;
         *     VipsForeignClass *foreign_class = (VipsForeignClass *) class;
         *     VipsForeignSaveClass *save_class = (VipsForeignSaveClass *) class;
         *
         *     gobject_class->set_property = vips_object_set_property;
         *     gobject_class->get_property = vips_object_get_property;
         *
         *     object_class->nickname = "csvsave";
         *     object_class->description = _("save image to csv file");
         *     object_class->build = vips_foreign_save_csv_build;
         *
         *     foreign_class->suffs = vips__foreign_csv_suffs;
         *
         *     save_class->saveable = VIPS_FOREIGN_SAVEABLE_MONO;
         *     // no need to define ->format_table, we don't want the input
         *     // cast for us
         *
         *     VIPS_ARG_STRING(class, "filename", 1,
         *         _("Filename"),
         *         _("Filename to save to"),
         *         VIPS_ARGUMENT_REQUIRED_INPUT,
         *         G_STRUCT_OFFSET(VipsForeignSaveCsv, filename),
         *         NULL);
         *
         *     VIPS_ARG_STRING(class, "separator", 13,
         *         _("Separator"),
         *         _("Separator characters"),
         *         VIPS_ARGUMENT_OPTIONAL_INPUT,
         *         G_STRUCT_OFFSET(VipsForeignSaveCsv, separator),
         *         "\t");
         * }
         *
         * static void
         * vips_foreign_save_csv_init(VipsForeignSaveCsv *csv)
         * {
         *     csv->separator = g_strdup("\t");
         * }
         * ```
         */
        abstract class ForeignSave extends Foreign {
            static $gtype: GObject.GType<ForeignSave>;

            // Properties

            get background(): ArrayDouble;
            set background(val: ArrayDouble);
            get in(): Image;
            set in(val: Image);
            get keep(): ForeignKeep;
            set keep(val: ForeignKeep);
            get page_height(): number;
            set page_height(val: number);
            get pageHeight(): number;
            set pageHeight(val: number);
            get profile(): string;
            set profile(val: string);
            get strip(): boolean;
            set strip(val: boolean);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: ForeignSave.SignalSignatures;

            // Fields

            parent_object: Foreign;
            ready: Image;

            // Constructors

            constructor(properties?: Partial<ForeignSave.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            // Signals

            connect<K extends keyof ForeignSave.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ForeignSave.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof ForeignSave.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ForeignSave.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof ForeignSave.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<ForeignSave.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;
        }

        namespace Image {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                eval: (arg0: Progress) => void;
                invalidate: () => void;
                minimise: () => void;
                posteval: (arg0: Progress) => void;
                preeval: (arg0: Progress) => void;
                written: (arg0: number) => void;
                'notify::bands': (pspec: GObject.ParamSpec) => void;
                'notify::coding': (pspec: GObject.ParamSpec) => void;
                'notify::demand': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::foreign-buffer': (pspec: GObject.ParamSpec) => void;
                'notify::format': (pspec: GObject.ParamSpec) => void;
                'notify::height': (pspec: GObject.ParamSpec) => void;
                'notify::interpretation': (pspec: GObject.ParamSpec) => void;
                'notify::kill': (pspec: GObject.ParamSpec) => void;
                'notify::mode': (pspec: GObject.ParamSpec) => void;
                'notify::sizeof-header': (pspec: GObject.ParamSpec) => void;
                'notify::width': (pspec: GObject.ParamSpec) => void;
                'notify::xoffset': (pspec: GObject.ParamSpec) => void;
                'notify::xres': (pspec: GObject.ParamSpec) => void;
                'notify::yoffset': (pspec: GObject.ParamSpec) => void;
                'notify::yres': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {
                bands: number;
                coding: Coding;
                demand: DemandStyle;
                filename: string;
                foreign_buffer: any;
                foreignBuffer: any;
                format: BandFormat;
                height: number;
                interpretation: Interpretation;
                kill: boolean;
                mode: string;
                sizeof_header: number;
                sizeofHeader: number;
                width: number;
                xoffset: number;
                xres: number;
                yoffset: number;
                yres: number;
            }
        }

        /**
         * The [class`Image]` class and associated types and macros.
         *
         * Images can be created from formatted files on disc, from C-style arrays on
         * disc, from formatted areas of memory, or from C-style arrays in memory. See
         * [ctor`Image`.new_from_file] and friends.
         * Creating an image is fast. libvips reads just enough of
         * the image to be able to get the various properties, such as width in
         * pixels. It delays reading any pixels until they are really needed.
         *
         * Once you have an image, you can get properties from it in the usual way.
         * You can use projection functions, like [method`Image`.get_width] or
         * [method`GObject`.Object.get], to get [class`GObject`.Object] properties.
         *
         * `.v` images are three-dimensional arrays, the dimensions being width,
         * height and bands. Each dimension can be up to 2 ** 31 pixels (or band
         * elements). An image has a format, meaning the machine number type used
         * to represent each value. libvips supports 10 formats, from 8-bit unsigned
         * integer up to 128-bit double complex, see [method`Image`.get_format].
         *
         * In libvips, images are uninterpreted arrays, meaning that from the point
         * of view of most operations, they are just large collections of numbers.
         * There's no difference between an RGBA (RGB with alpha) image and a CMYK
         * image, for example, they are both just four-band images. It's up to the
         * user of the library to pass the right sort of image to each operation.
         *
         * To take an example, libvips has [method`Image`.Lab2XYZ], an operation to
         * transform an image from CIE LAB colour space to CIE XYZ space. It assumes
         * the first three bands represent pixels in LAB colour space and returns an
         * image where the first three bands are transformed to XYZ and any
         * remaining bands are just copied. Pass it an RGB image by mistake and
         * you'll just get nonsense.
         *
         * libvips has a feature to help (a little) with this: it sets a
         * [enum`Interpretation]` hint for each image (see
         * [method`Image`.get_interpretation]); a hint which says how pixels should
         * be interpreted. For example, [method`Image`.Lab2XYZ] will set the
         * interpretation of the output image to [enum`Vips`.Interpretation.XYZ].
         * A few utility operations will also use interpretation as a guide. For
         * example, you can give [method`Image`.colourspace] an input image and a
         * desired colourspace and it will use the input's interpretation hint to
         * apply the best sequence of colourspace transforms to get to the desired
         * space.
         *
         * Use things like [method`Image`.invert] to manipulate your images. When you
         * are done, you can write images to disc files (with
         * [method`Image`.write_to_file]), to formatted memory buffers (with
         * [method`Image`.write_to_buffer]) and to C-style memory arrays (with
         * [method`Image`.write_to_memory]).
         *
         * You can also write images to other images. Create, for example, a temporary
         * disc image with [ctor`Image`.new_temp_file], then write your image to that
         * with [method`Image`.write]. You can create several other types of image and
         * write to them, see [ctor`Image`.new_memory], for example.
         *
         * See [class`Operation]` for an introduction to running operations on images,
         * see [Image headers](libvips-header.html) for getting and setting image
         * metadata. See [class`Object]` for a discussion of the lower levels.
         */
        class Image extends Object {
            static $gtype: GObject.GType<Image>;

            // Properties

            get bands(): number;
            set bands(val: number);
            get coding(): Coding;
            set coding(val: Coding);
            get demand(): DemandStyle;
            set demand(val: DemandStyle);
            get filename(): string;
            set filename(val: string);
            get foreign_buffer(): any;
            set foreign_buffer(val: any);
            get foreignBuffer(): any;
            set foreignBuffer(val: any);
            get format(): BandFormat;
            set format(val: BandFormat);
            get height(): number;
            set height(val: number);
            get interpretation(): Interpretation;
            set interpretation(val: Interpretation);
            get kill(): boolean;
            set kill(val: boolean);
            get mode(): string;
            set mode(val: string);
            get sizeof_header(): number;
            set sizeof_header(val: number);
            get sizeofHeader(): number;
            set sizeofHeader(val: number);
            get width(): number;
            set width(val: number);
            get xoffset(): number;
            set xoffset(val: number);
            get xres(): number;
            set xres(val: number);
            get yoffset(): number;
            set yoffset(val: number);
            get yres(): number;
            set yres(val: number);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Image.SignalSignatures;

            // Constructors

            constructor(properties?: Partial<Image.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static memory(): Image;

            static ['new'](): Image;

            static new_from_file_RW(filename: string): Image;

            static new_from_file_raw(
                filename: string,
                xsize: number,
                ysize: number,
                bands: number,
                offset: number,
            ): Image;

            static new_from_image(image: Image, c: number[]): Image;

            static new_from_image1(image: Image, c: number): Image;

            static new_from_memory(
                data: Uint8Array | string,
                width: number,
                height: number,
                bands: number,
                format: BandFormat,
            ): Image;

            static new_from_memory_copy(
                data: Uint8Array | string,
                width: number,
                height: number,
                bands: number,
                format: BandFormat,
            ): Image;

            static new_matrix(width: number, height: number): Image;

            static new_matrix_from_array(width: number, height: number, array: number[]): Image;

            static new_temp_file(format: string): Image;

            // Signals

            connect<K extends keyof Image.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Image.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Image.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Image.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Image.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Image.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            static get_format_max(format: BandFormat): number;
            /**
             * Add an image to a pipeline. `image` depends on all of the images in `in,`
             * `image` prefers to supply pixels according to `hint`.
             *
             * Operations can set demand hints, that is, hints to the VIPS IO system about
             * the type of region geometry they work best with. For example,
             * operations which transform coordinates will usually work best with
             * [enum`Vips`.DemandStyle.SMALLTILE], operations which work on local windows of
             * pixels will like [enum`Vips`.DemandStyle.FATSTRIP].
             *
             * Header fields in `image` are set from the fields in `in,` with lower-numbered
             * images in `in` taking priority.
             * For example, if `in[`0] and `in[`1] both have an item
             * called "icc-profile", it's the profile attached to `in[`0] that will end up
             * on `image`.
             * Image history is completely copied from all `in`. `image` will have the history
             * of all the input images.
             * The array of input images can be empty, meaning `image` is at the start of a
             * pipeline.
             *
             * VIPS uses the list of input images to build the tree of operations it needs
             * for the cache invalidation system.
             *
             * ::: seealso
             *     [method`Image`.pipelinev], [method`Image`.generate].
             * @param hint demand hint for @image
             * @param _in `NULL`-terminated array of input images
             */
            static pipeline_array(hint: DemandStyle, _in: Image[]): [number, Image];

            // Virtual methods

            vfunc_eval(progress: Progress, data?: any | null): void;
            vfunc_invalidate(data?: any | null): void;
            vfunc_minimise(data?: any | null): void;
            vfunc_posteval(progress: Progress, data?: any | null): void;
            vfunc_preeval(progress: Progress, data?: any | null): void;
            vfunc_written(result: number, data?: any | null): void;

            // Methods

            /**
             * Remove the orientation tag on `image`. Also remove any exif orientation tags.
             * You must [method`Image`.copy] the image before calling this function since it
             * modifies metadata.
             */
            autorot_remove_angle(): void;
            /**
             * Test if `image` is in a colourspace that [method`Image`.colourspace] can process.
             * @returns `TRUE` if @image is in a supported colourspace.
             */
            colourspace_issupported(): boolean;
            /**
             * This function allocates memory, renders `image` into it, builds a new
             * image around the memory area, and returns that.
             *
             * If the image is already a simple area of memory, it just refs `image` and
             * returns it.
             *
             * Call this before using the draw operations to make sure you have a
             * memory image that can be modified.
             *
             * [method`Image`.copy] adds a null "copy" node to a pipeline. Use that
             * instead if you want to change metadata and not pixels.
             *
             * This operation is thread-safe, unlike [method`Image`.wio_input].
             *
             * If you are sure that `image` is not shared with another thread (perhaps you
             * have made it yourself), use [method`Image`.wio_input] instead.
             *
             * ::: seealso
             *     [method`Image`.wio_input].
             * @returns the new [class@Image], or `NULL` on error.
             */
            copy_memory(): Image;
            /**
             * A convenience function to unpack to a format that we can compute with.
             * `out`.coding is always [enum`Vips`.Coding.NONE].
             *
             * This unpacks LABQ to plain LAB. Use [method`Image`.LabQ2LabS] for a bit
             * more speed if you need it.
             *
             * ::: seealso
             *     [method`Image`.encode], [method`Image`.LabQ2Lab], [method`Image`.rad2float].
             * @returns 0 on success, or -1 on error.
             */
            decode(): [number, Image];
            /**
             * We often need to know what an image will decode to without actually
             * decoding it, for example, in arg checking.
             *
             * ::: seealso
             *     [method`Image`.decode].
             */
            decode_predict(): [number, number, BandFormat];
            /**
             * A convenience function to pack to a coding. The inverse of
             * [method`Image`.decode].
             *
             * ::: seealso
             *     [method`Image`.decode].
             * @param coding coding to apply
             * @returns 0 on success, or -1 on error.
             */
            encode(coding: Coding | null): [number, Image];
            ['eval'](processed: number): void;
            /**
             * Loaders can call this on the image they are making if they see a read error
             * from the load library. It signals "invalidate" on the load operation and
             * will cause it to be dropped from cache.
             *
             * If we know a file will cause a read error, we don't want to cache the
             * failing operation, we want to make sure the image will really be opened
             * again if our caller tries again. For example, a broken file might be
             * replaced by a working one.
             */
            foreign_load_invalidate(): void;
            /**
             * Free the externally allocated buffer found in the input image. This function
             * is intended to be used with g_signal_connect.
             * @param buffer the original buffer that was stolen
             */
            free_buffer(buffer?: any | null): void;
            /**
             * Generates an image. The action depends on the image type.
             *
             * For images created with [ctor`Image`.new], [method`Image`.generate] just
             * attaches the start/generate/stop callbacks and returns.
             *
             * For images created with [ctor`Image`.new_memory], memory is allocated for
             * the whole image and it is entirely generated using [func`sink_memory]`.
             *
             * For images created with [ctor`Image`.new_temp_file] and friends, memory for
             * a few scanlines is allocated and
             * [method`Image`.sink_disc] used to generate the image in small chunks. As each
             * chunk is generated, it is written to disc.
             *
             * ::: seealso
             *     [func`sink_memory]`, [ctor`Image`.new], [method`Region`.prepare].
             * @param start_fn start sequences with this function
             * @param generate_fn generate pixels with this function
             * @param stop_fn stop sequences with this function
             * @param a user data
             * @param b user data
             * @returns 0 on success, or -1 on error.
             */
            generate(
                start_fn: StartFn,
                generate_fn: GenerateFn,
                stop_fn: StopFn,
                a?: any | null,
                b?: any | null,
            ): number;
            /**
             * Fill `value_copy` with a copy of the header field. `value_copy` must be zeroed
             * but uninitialised.
             *
             * This will return -1 and add a message to the error buffer if the field
             * does not exist. Use [method`Image`.get_typeof] to test for the
             * existence of a field first if you are not certain it will be there.
             *
             * For example, to read a double from an image (though of course you would use
             * [method`Image`.get_double] in practice):
             *
             * ```c
             * GValue value = G_VALUE_INIT;
             * double d;
             *
             * if (vips_image_get(image, name, &value))
             *     return -1;
             *
             * if (G_VALUE_TYPE(&value) != G_TYPE_DOUBLE) {
             *     vips_error("mydomain",
             *         _("field \"%s\" is of type %s, not double"),
             *         name,
             *         g_type_name(G_VALUE_TYPE(&value)));
             *     g_value_unset(&value);
             *     return -1;
             * }
             *
             * d = g_value_get_double(&value);
             * g_value_unset(&value);
             * ```
             *
             * ::: seealso
             *     [method`Image`.get_typeof], [method`Image`.get_double].
             * @param name the name to fetch
             * @returns 0 on success, -1 otherwise.
             */
            get(name: string): [number, unknown];
            /**
             * Gets `data` from `image` under the name `name`. A convenience
             * function over [method`Image`.get]. Use [method`Image`.get_typeof] to
             * test for the existence of a piece of metadata.
             *
             * ::: seealso
             *     [method`Image`.set_area], [method`Image`.get],
             *     [method`Image`.get_typeof].
             * @param name metadata name
             * @returns 0 on success, -1 otherwise.
             */
            get_area(name: string): [number, any];
            /**
             * Gets `out` from `im` under the name `name`.
             * The field must be of type `VIPS_TYPE_ARRAY_INT`.
             *
             * Do not free `out`. `out` is valid as long as `image` is valid.
             *
             * Use [method`Image`.get_typeof] to test for the
             * existence of a piece of metadata.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.set_image]
             * @param name metadata name
             * @returns 0 on success, -1 otherwise.
             */
            get_array_double(name: string): [number, number[]];
            /**
             * Gets `out` from `im` under the name `name`.
             * The field must be of type `VIPS_TYPE_ARRAY_INT`.
             *
             * Do not free `out`. `out` is valid as long as `image` is valid.
             *
             * Use [method`Image`.get_typeof] to test for the
             * existence of a piece of metadata.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.set_image]
             * @param name metadata name
             * @returns 0 on success, -1 otherwise.
             */
            get_array_int(name: string): [number, number[]];
            /**
             * Returns `name` from `image` in `out`.
             * This function will read any field, returning it as a printable string.
             * You need to free the string with [func`GLib`.free] when you are done with it.
             *
             * This will base64-encode BLOBs, for example. Use [method`Buf`.appendg] to
             * make a string that's for humans.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.get_typeof],
             *     [method`Buf`.appendg].
             * @param name field name
             * @returns 0 on success, -1 otherwise.
             */
            get_as_string(name: string): [number, string];
            get_bands(): number;
            /**
             * Gets `data` from `image` under the name `name,` optionally returns its
             * length in `length`. Use [method`Image`.get_typeof] to test for the existence
             * of a piece of metadata.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.get_typeof],
             *     [method`Blob`.get].
             * @param name metadata name
             * @returns 0 on success, -1 otherwise.
             */
            get_blob(name: string): [number, Uint8Array];
            get_coding(): Coding;
            /**
             * Fetch and sanity-check [const`META_CONCURRENCY]`. Default to 1 if not
             * present or crazy.
             * @param default_concurrency
             * @returns the suggested concurrency for this image
             */
            get_concurrency(default_concurrency: number): number;
            /**
             * Return a pointer to the image's pixel data, if possible. This can involve
             * allocating large amounts of memory and performing a long computation. Image
             * pixels are laid out in band-packed rows.
             *
             * Since this function modifies `image,` it is not threadsafe. Only call it on
             * images which you are sure have not been shared with another thread.
             *
             * ::: seealso
             *     [method`Image`.wio_input], [method`Image`.copy_memory].
             * @returns a pointer to pixel data, if possible.
             */
            get_data(): any | null;
            /**
             * Gets `out` from `im` under the name `name`.
             * The value will be transformed into a double, if possible.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.get_typeof].
             * @param name field name
             * @returns 0 on success, -1 otherwise.
             */
            get_double(name: string): [number, number];
            /**
             * Get a `NULL`-terminated array listing all the metadata field names on `image`.
             * Free the return result with [func`GLib`.strfreev].
             *
             * This is handy for language bindings. From C, it's usually more convenient to
             * use [method`Image`.map].
             * @returns metadata fields in image, as a `NULL`-terminated   array.
             */
            get_fields(): string[];
            get_filename(): string;
            get_format(): BandFormat;
            get_height(): number;
            /**
             * This function reads the image history as a C string. The string is owned
             * by VIPS and must not be freed.
             *
             * VIPS tracks the history of each image, that is, the sequence of operations
             * that generated that image. Applications built on VIPS need to call
             * [method`Image`.history_printf] for each action they perform, setting the
             * command-line equivalent for the action.
             *
             * ::: seealso
             *     [method`Image`.history_printf].
             * @returns The history of @image as a C string. Do not free!
             */
            get_history(): string;
            /**
             * Gets `out` from `im` under the name `name`.
             * The field must be of type `VIPS_TYPE_IMAGE`.
             * You must unref `out` with [method`GObject`.Object.unref].
             *
             * Use [method`Image`.get_typeof] to test for the
             * existence of a piece of metadata.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.set_image]
             * @param name metadata name
             * @returns 0 on success, -1 otherwise.
             */
            get_image(name: string): [number, Image];
            /**
             * Gets `out` from `im` under the name `name`.
             * The value will be transformed into an int, if possible.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.get_typeof].
             * @param name field name
             * @returns 0 on success, -1 otherwise.
             */
            get_int(name: string): [number, number];
            /**
             * Return the [enum`Interpretation]` set in the image header.
             * Use [method`Image`.guess_format] if you want a sanity-checked value.
             * @returns the [enum@Interpretation] from the image header.
             */
            get_interpretation(): Interpretation;
            /**
             * Image modes are things like `"t"`, meaning a memory buffer, and `"p"`
             * meaning a delayed computation.
             * @returns the image mode.
             */
            get_mode(): string;
            /**
             * Fetch and sanity-check [const`META_N_PAGES]`. Default to 1 if not present
             * or crazy.
             *
             * This is the number of pages in the image file, not the number of pages that
             * have been loaded into `image`.
             * @returns the number of pages in the image file
             */
            get_n_pages(): number;
            /**
             * Fetch and sanity-check [const`META_N_SUBIFDS]`. Default to 0 if not
             * present or crazy.
             * @returns the number of subifds in the image file
             */
            get_n_subifds(): number;
            /**
             * Matrix images can have an optional `offset` field for use by integer
             * convolution.
             * @returns the offset.
             */
            get_offset(): number;
            /**
             * Fetch and sanity-check [const`META_ORIENTATION]`. Default to 1 (no rotate,
             * no flip) if not present or crazy.
             * @returns the image orientation.
             */
            get_orientation(): number;
            /**
             * Return `TRUE` if applying the orientation would swap width and height.
             * @returns if width/height will swap
             */
            get_orientation_swap(): boolean;
            /**
             * Multi-page images can have a page height. Fetch it, and sanity check it. If
             * page-height is not set, it defaults to the image height.
             * @returns the page height.
             */
            get_page_height(): number;
            /**
             * Matrix images can have an optional `scale` field for use by integer
             * convolution.
             * @returns the scale.
             */
            get_scale(): number;
            /**
             * Gets `out` from `im` under the name `name`.
             * The field must be of type `G_TYPE_STRING` or `VIPS_TYPE_REF_STRING`.
             *
             * Do not free `out`.
             *
             * Use [method`Image`.get_as_string] to fetch any field as a string.
             *
             * ::: seealso
             *     [method`Image`.get], [method`Image`.get_typeof].
             * @param name field name
             * @returns 0 on success, -1 otherwise.
             */
            get_string(name: string): [number, string];
            /**
             * Pick a tile size and a buffer height for this image and the current
             * value of [func`concurrency_get]`. The buffer height
             * will always be a multiple of tile_height.
             *
             * The buffer height is the height of each buffer we fill in sink disc. Since
             * we have two buffers, the largest range of input locality is twice the output
             * buffer size, plus whatever margin we add for things like convolution.
             */
            get_tile_size(): [number, number, number];
            /**
             * Read the [alias`GObject`.Type] for a header field. Returns zero if there
             * is no field of that name.
             *
             * ::: seealso
             *     [method`Image`.get].
             * @param name the name to search for
             * @returns the [alias@GObject.Type] of the field, or zero if there is no   field of that name.
             */
            get_typeof(name: string): GObject.GType;
            get_width(): number;
            get_xoffset(): number;
            get_xres(): number;
            get_yoffset(): number;
            get_yres(): number;
            /**
             * Return the [enum`BandFormat]` for an image, guessing a sane value if
             * the set value looks crazy.
             *
             * For example, for a float image tagged as rgb16, we'd return ushort.
             * @returns a sensible [enum@BandFormat] for the image.
             */
            guess_format(): BandFormat;
            /**
             * Return the [enum`Interpretation]` for an image, guessing a sane value if
             * the set value looks crazy.
             * @returns a sensible [enum@Interpretation] for the image.
             */
            guess_interpretation(): Interpretation;
            /**
             * Look at an image's interpretation and see if it has extra alpha bands. For
             * example, a 4-band [enum`Vips`.Interpretation.sRGB] would, but a six-band
             * [enum`Vips`.Interpretation.MULTIBAND] would not.
             *
             * Return `TRUE` if `image` has an alpha channel.
             */
            hasalpha(): boolean;
            /**
             * Formats the name/argv as a single string and calls
             * [method`Image`.history_printf]. A convenience function for
             * command-line programs.
             *
             * ::: seealso
             *     [method`Image`.get_history].
             * @param name program name
             * @param argv program arguments
             * @returns 0 on success, -1 on error.
             */
            history_args(name: string, argv: string[]): number;
            /**
             * Transform an image from absolute to relative colorimetry using the
             * MediaWhitePoint stored in the ICC profile.
             *
             * ::: seealso
             *     [method`Image`.icc_transform], [method`Image`.icc_import].
             * @param profile_filename use this profile
             * @returns 0 on success, -1 on error.
             */
            icc_ac2rc(profile_filename: string): [number, Image];
            /**
             * A convenience function to set the header fields after creating an image.
             * Normally you copy the fields from your input images with
             * [method.Image.pipelinev] and then make any adjustments you need,
             * but if you are creating an image from scratch, for example
             * [ctor`Image`.black] or [ctor`Image`.jpegload], you do need to set all the
             * fields yourself.
             *
             * ::: seealso
             *     [method.Image.pipelinev].
             * @param xsize image width
             * @param ysize image height
             * @param bands image bands
             * @param format band format
             * @param coding image coding
             * @param interpretation image type
             * @param xres horizontal resolution, pixels per millimetre
             * @param yres vertical resolution, pixels per millimetre
             */
            init_fields(
                xsize: number,
                ysize: number,
                bands: number,
                format: BandFormat | null,
                coding: Coding | null,
                interpretation: Interpretation | null,
                xres: number,
                yres: number,
            ): void;
            /**
             * Gets `image` ready for an in-place operation, such as
             * [method`Image`.draw_circle]. After calling this function you can both read
             * and write the image with [func`IMAGE_ADDR]`.
             *
             * This method is called for you by the base class of the draw operations,
             * there's no need to call it yourself.
             *
             * Since this function modifies `image,` it is not thread-safe. Only call it on
             * images which you are sure have not been shared with another thread.
             * All in-place operations are inherently not thread-safe, so you need to take
             * great care in any case.
             *
             * ::: seealso
             *     [method`Image`.draw_circle], [method`Image`.wio_input].
             * @returns 0 on success, or -1 on error.
             */
            inplace(): number;
            /**
             * Invalidate all pixel caches on `image` and any downstream images, that
             * is, images which depend on this image. Additionally, all operations which
             * depend upon this image are dropped from the VIPS operation cache.
             *
             * You should call this function after destructively modifying an image with
             * something like [method`Image`.draw_circle].
             *
             * The [signal`Image:`:invalidate] signal is emitted for all invalidated images.
             *
             * ::: seealso
             *     [method`Region`.invalidate].
             */
            invalidate_all(): void;
            /**
             * Return `TRUE` if `image` is in most-significant-
             * byte first form. This is the byte order used on the SPARC
             * architecture and others.
             */
            isMSBfirst(): boolean;
            /**
             * `TRUE` if any of the images upstream from `image` were opened in sequential
             * mode. Some operations change behaviour slightly in sequential mode to
             * optimize memory behaviour.
             * @returns `TRUE` if @image is in sequential mode.
             */
            is_sequential(): boolean;
            /**
             * Return `TRUE` if `image` represents a file on disc in some way.
             */
            isfile(): boolean;
            /**
             * If `image` has been killed (see [method`Image`.set_kill]), set an error message,
             * clear the [class`Image]`.kill flag and return `TRUE`. Otherwise return `FALSE`.
             *
             * Handy for loops which need to run sets of threads which can fail.
             *
             * ::: seealso
             *     [method`Image`.set_kill].
             * @returns `TRUE` if @image has been killed.
             */
            iskilled(): boolean;
            /**
             * Return `TRUE` if `im` represents a partial image (a delayed calculation).
             */
            ispartial(): boolean;
            /**
             * This function calls `fn` for every header field, including every item of
             * metadata.
             *
             * Like all _map functions, the user function should return `NULL` to continue
             * iteration, or a non-`NULL` pointer to indicate early termination.
             *
             * ::: seealso
             *     [method`Image`.get_typeof], [method`Image`.get].
             * @param fn function to call for each header field
             * @returns `NULL` on success, the failing   pointer otherwise.
             */
            map(fn: ImageMapFn): any | null;
            /**
             * Minimise memory use on this image and any upstream images, that is, images
             * which this image depends upon. This function is called automatically at the
             * end of a computation, but it might be useful to call at other times.
             *
             * The [signal`Image:`:minimise] signal is emitted for all minimised images.
             */
            minimise_all(): void;
            /**
             * Check that an image is readable with [method`Region`.prepare] and friends.
             * If it isn't, try to transform the image so that [method`Region`.prepare] can
             * work.
             *
             * ::: seealso
             *     [method`Image`.pio_output], [method`Region`.prepare].
             * @returns 0 on success, or -1 on error.
             */
            pio_input(): number;
            /**
             * Check that an image is writeable with [method`Image`.generate]. If it isn't,
             * try to transform the image so that [method`Image`.generate] can work.
             *
             * ::: seealso
             *     [method`Image`.pio_input].
             * @returns 0 on success, or -1 on error.
             */
            pio_output(): number;
            posteval(): void;
            preeval(): void;
            /**
             * Prints field `name` to stdout as ASCII. Handy for debugging.
             * @param name field name
             */
            print_field(name: string): void;
            /**
             * Find and remove an item of metadata. Return `FALSE` if no metadata of that
             * name was found.
             *
             * ::: seealso
             *     [method`Image`.set], [method`Image`.get_typeof].
             * @param name the name to search for
             * @returns `TRUE` if an item of metadata of that name was found and removed
             */
            remove(name: string): boolean;
            /**
             * [method`Image`.reorder_margin_hint] sets a hint that `image` contains a
             * margin, that is, that each [method`Region`.prepare] on `image` will request
             * a slightly larger region from it's inputs. A good value for `margin` is
             * (width * height) for the window the operation uses.
             *
             * This information is used by [method`Image`.reorder_prepare_many] to attempt to
             * reorder computations to minimise recomputation.
             *
             * ::: seealso
             *     [method`Image`.reorder_prepare_many].
             * @param margin the size of the margin this operation has added
             */
            reorder_margin_hint(margin: number): void;
            /**
             * [method`Image`.reorder_prepare_many] runs [method`Region`.prepare] on each
             * region in `regions,` requesting the pixels in `r`.
             *
             * It tries to request the regions in the order which will cause least
             * recomputation. This can give a large speedup, in some cases.
             *
             * ::: seealso
             *     [method`Region`.prepare], [method`Image`.reorder_margin_hint].
             * @param regions the set of regions to prepare
             * @param r the [struct@Rect] to prepare on each region
             * @returns 0 on success, or -1 on error.
             */
            reorder_prepare_many(regions: Region[], r: Rect): number;
            /**
             * Set a piece of metadata on `image`. Any old metadata with that name is
             * destroyed. The [struct`GObject`.Value] is copied into the image, so you need to unset the
             * value when you're done with it.
             *
             * For example, to set an integer on an image (though you would use the
             * convenience function [method`Image`.set_int] in practice), you would do:
             *
             * ```c
             * GValue value = G_VALUE_INIT;
             *
             * g_value_init(&value, G_TYPE_INT);
             * g_value_set_int(&value, 42);
             * vips_image_set(image, name, &value);
             * g_value_unset(&value);
             * ```
             *
             * ::: seealso
             *     [method`Image`.get].
             * @param name the name to give the metadata
             * @param value the [struct@GObject.Value] to copy into the image
             */
            set(name: string, value: GObject.Value | any): void;
            // Conflicted with GObject.Object.set
            set(...args: never[]): any;
            /**
             * Attaches `data` as a metadata item on `image` under the name `name`. When
             * VIPS no longer needs the metadata, it will be freed with `free_fn`.
             *
             * ::: seealso
             *     [method`Image`.get_double], [method`Image`.set].
             * @param name metadata name
             * @param free_fn free function for @data
             */
            set_area(name: string, free_fn?: CallbackFn | null): void;
            /**
             * Attaches `array` as a metadata item on `image` as `name`.
             * A convenience function over [method`Image`.set].
             *
             * ::: seealso
             *     [method`Image`.get_image], [method`Image`.set].
             * @param name metadata name
             * @param array array of doubles
             */
            set_array_double(name: string, array?: number[] | null): void;
            /**
             * Attaches `array` as a metadata item on `image` as `name`.
             * A convenience function over [method`Image`.set].
             *
             * ::: seealso
             *     [method`Image`.get_image], [method`Image`.set].
             * @param name metadata name
             * @param array array of ints
             */
            set_array_int(name: string, array?: number[] | null): void;
            /**
             * Attaches `data` as a metadata item on `image` under the name `name`.
             *
             * ::: seealso
             *     [method`Image`.get_blob], [method`Image`.set].
             * @param name metadata name
             * @param free_fn free function for @data
             * @param data pointer to area of   memory
             */
            set_blob(name: string, free_fn: CallbackFn | null, data: Uint8Array | string): void;
            /**
             * Attaches `data` as a metadata item on `image` under the name `name,` taking
             * a copy of the memory area.
             *
             * ::: seealso
             *     [method`Image`.get_blob], [method`Image`.set].
             * @param name metadata name
             * @param data pointer to area of memory
             */
            set_blob_copy(name: string, data: Uint8Array | string): void;
            /**
             * Sets the delete_on_close flag for the image. If this flag is set, when
             * `image` is finalized, the filename held in `image->`filename at the time of
             * this call is deleted.
             *
             * This function is clearly extremely dangerous, use with great caution.
             *
             * ::: seealso
             *     [ctor`Image`.new_temp_file].
             * @param delete_on_close format of file
             */
            set_delete_on_close(delete_on_close: boolean): void;
            /**
             * Attaches `d` as a metadata item on `image` as `name`. A
             * convenience function over [method`Image`.set].
             *
             * ::: seealso
             *     [method`Image`.get_double], [method`Image`.set].
             * @param name metadata name
             * @param d metadata value
             */
            set_double(name: string, d: number): void;
            /**
             * Attaches `im` as a metadata item on `image` as `name`.
             * A convenience function over [method`Image`.set].
             *
             * ::: seealso
             *     [method`Image`.get_image], [method`Image`.set].
             * @param name metadata name
             * @param im metadata value
             */
            set_image(name: string, im: Image): void;
            /**
             * Attaches `i` as a metadata item on `image` under the name `name`. A
             * convenience function over [method`Image`.set].
             *
             * ::: seealso
             *     [method`Image`.get_int], [method`Image`.set].
             * @param name metadata name
             * @param i metadata value
             */
            set_int(name: string, i: number): void;
            /**
             * Set the [class`Image]`.kill flag on an image. Handy for stopping sets of
             * threads.
             *
             * ::: seealso
             *     [method`Image`.iskilled].
             * @param kill the kill state
             */
            set_kill(kill: boolean): void;
            /**
             * vips signals evaluation progress via the [signal`Image:`:preeval],
             * [signal`Image:`:eval] and [signal`Image:`:posteval]
             * signals. Progress is signalled on the most-downstream image for which
             * [method`Image`.set_progress] was called.
             * @param progress turn progress reporting on or off
             */
            set_progress(progress: boolean): void;
            /**
             * Attaches `str` as a metadata item on `image` as `name`.
             * A convenience
             * function over [method`Image`.set] using `VIPS_TYPE_REF_STRING`.
             *
             * ::: seealso
             *     [method`Image`.get_double], [method`Image`.set].
             * @param name metadata name
             * @param str metadata value
             */
            set_string(name: string, str: string): void;
            /**
             * Loops over an image. `generate_fn` is called for every pixel in
             * the image, with the `reg` argument being a region of calculated pixels.
             * [method`Image`.sink] is used to implement operations like
             * [method`Image`.avg] which have no image output.
             *
             * Each set of pixels is sized according to the requirements of the image
             * pipeline that generated `im`.
             *
             * ::: seealso
             *     [method`Image`.generate], [ctor`Image`.new].
             * @param start_fn start sequences with this function
             * @param generate_fn generate pixels with this function
             * @param stop_fn stop sequences with this function
             * @param a user data
             * @param b user data
             * @returns 0 on success, or -1 on error.
             */
            sink(start_fn: StartFn, generate_fn: GenerateFn, stop_fn: StopFn, a?: any | null, b?: any | null): number;
            /**
             * [method`Image`.sink_disc] loops over `im,` top-to-bottom, generating it in sections.
             * As each section is produced, `write_fn` is called.
             *
             * `write_fn` is always called single-threaded (though not always from the same
             * thread), it's always given image
             * sections in top-to-bottom order, and there are never any gaps.
             *
             * This operation is handy for making image sinks which output to things like
             * disc files. Things like [method`Image`.jpegsave], for example, use this to write
             * images to files in JPEG format.
             *
             * ::: seealso
             *     [func`concurrency_set]`.
             * @param write_fn called for every batch of pixels
             * @returns 0 on success, -1 on error.
             */
            sink_disc(write_fn: RegionWrite): number;
            /**
             * This operation renders `in` in the background, making pixels available
             * on `out` as they are calculated. The `notify_fn` callback is run every
             * time a new set of pixels are available. Calculated pixels are kept in
             * a cache with tiles sized `tile_width` by `tile_height` pixels and with at
             * most `max_tiles` tiles.  If `max_tiles` is -1, the cache is of unlimited
             * size (up to the maximum image * size). The `mask` image is a one-band
             * uchar image and has 255 for pixels which are currently in cache and 0
             * for uncalculated pixels.
             *
             * Renders with a positive priority are assumed to be large, gh-priority,
             * foreground images. Although there can be many of these, only one is ever
             * active, to avoid overcommitting threads.
             *
             * Renders with a negative priority are assumed to be small, thumbnail images
             * consisting of a single tile. Single tile images are effectively
             * single-threaded, so all these renders are evaluated together.
             *
             * Calls to [method`Region`.prepare] on `out` return immediately and hold
             * whatever is currently in cache for that [struct`Rect]` (check `mask` to see
             * which parts of the [struct`Rect]` are valid). Any pixels in the [struct`Rect]`
             * which are not in cache are added to a queue, and the `notify_fn`
             * callback will trigger when those pixels are ready.
             *
             * The `notify_fn` callback is run from one of the background threads. In the
             * callback you need to somehow send a message to the main thread that the
             * pixels are ready. In a glib-based application, this is easily done with
             * [func`GLib`.idle_add].
             *
             * If `notify_fn` is `NULL` then [method`Image`.sink_screen] runs synchronously.
             * [method`Region`.prepare] on `out` will always block until the pixels have been
             * calculated.
             *
             * ::: seealso
             *     [method`Image`.tilecache], [method`Region`.prepare],
             *     [method`Image`.sink_disc], [method`Image`.sink].
             * @param mask mask image indicating valid pixels
             * @param tile_width tile width
             * @param tile_height tile height
             * @param max_tiles maximum tiles to cache
             * @param priority rendering priority
             * @param notify_fn pixels are ready notification callback
             * @returns 0 on success, -1 on error.
             */
            sink_screen(
                mask: Image,
                tile_width: number,
                tile_height: number,
                max_tiles: number,
                priority: number,
                notify_fn?: SinkNotify | null,
            ): [number, Image];
            /**
             * Loops over an image. `generate_fn` is called for every
             * pixel in the image, with
             * the `reg` argument being a region of calculated pixels.
             *
             * Each set of pixels is `tile_width` by `tile_height` pixels (less at the
             * image edges). This is handy for things like writing a tiled TIFF image,
             * where tiles have to be generated with a certain size.
             *
             * ::: seealso
             *     [method`Image`.sink], [method`Image`.get_tile_size].
             * @param tile_width tile width
             * @param tile_height tile height
             * @param start_fn start sequences with this function
             * @param generate_fn generate pixels with this function
             * @param stop_fn stop sequences with this function
             * @param a user data
             * @param b user data
             * @returns 0 on success, or -1 on error.
             */
            sink_tile(
                tile_width: number,
                tile_height: number,
                start_fn: StartFn,
                generate_fn: GenerateFn,
                stop_fn: StopFn,
                a?: any | null,
                b?: any | null,
            ): number;
            /**
             * Check that an image is readable via the [func`IMAGE_ADDR]` macro, that is,
             * that the entire image is in memory and all pixels can be read with
             * [func`IMAGE_ADDR]`.  If it
             * isn't, try to transform it so that [func`IMAGE_ADDR]` can work.
             *
             * Since this function modifies `image,` it is not thread-safe. Only call it on
             * images which you are sure have not been shared with another thread. If the
             * image might have been shared, use the less efficient
             * [method`Image`.copy_memory] instead.
             *
             * ::: seealso
             *     [method`Image`.copy_memory], [method`Image`.pio_input],
             *     [method`Image`.inplace], [func`IMAGE_ADDR]`.
             * @returns 0 on success, or -1 on error.
             */
            wio_input(): number;
            /**
             * Write `image` to `out`. Use [ctor`Image`.new] and friends to create the
             * [class`Image]` you want to write to.
             *
             * ::: seealso
             *     [ctor`Image`.new], [method`Image`.copy], [method`Image`.write_to_file].
             * @returns 0 on success, or -1 on error.
             */
            write(): [number, Image];
            /**
             * Write a line of pixels to an image. This function must be called repeatedly
             * with `ypos` increasing from 0 to [property`Image:`height].
             * `linebuffer` must be [func`IMAGE_SIZEOF_LINE]` bytes long.
             *
             * ::: seealso
             *     [method`Image`.generate].
             * @param ypos vertical position of scan-line to write
             * @param linebuffer scanline of pixels
             * @returns 0 on success, or -1 on error.
             */
            write_line(ypos: number, linebuffer: Pel): number;
            /**
             * Call this after setting header fields (width, height, and so on) to
             * allocate resources ready for writing.
             *
             * Normally this function is called for you by [method`Image`.generate] or
             * [method`Image`.write_line]. You will need to call it yourself if you plan to
             * write directly to the ->data member of a memory image.
             * @returns 0 on success, or -1 on error.
             */
            write_prepare(): number;
            /**
             * Writes `in` to memory as a simple, unformatted C-style array.
             *
             * The caller is responsible for freeing this memory with [func`GLib`.free].
             *
             * ::: seealso
             *     [method`Image`.write_to_buffer].
             * @returns return buffer start here
             */
            write_to_memory(): Uint8Array;
        }

        namespace Interpolate {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {}
        }

        /**
         * An abstract base class for the various interpolation functions.
         *
         * Use `vips --list classes` to see all the interpolators available.
         *
         * An interpolator consists of a function to perform the interpolation, plus
         * some extra data fields which tells libvips how to call the function and
         * what data it needs.
         */
        abstract class Interpolate extends Object {
            static $gtype: GObject.GType<Interpolate>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Interpolate.SignalSignatures;

            // Fields

            parent_object: Object;

            // Constructors

            constructor(properties?: Partial<Interpolate.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](nickname: string): Interpolate;

            // Signals

            connect<K extends keyof Interpolate.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Interpolate.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Interpolate.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Interpolate.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Interpolate.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Interpolate.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            /**
             * A convenience function that returns a bilinear interpolator you
             * don't need to free.
             */
            static bilinear_static(): Interpolate;
            /**
             * A convenience function that returns a nearest-neighbour interpolator you
             * don't need to free.
             */
            static nearest_static(): Interpolate;

            // Virtual methods

            /**
             * Look up an interpolators desired window offset.
             */
            vfunc_get_window_offset(): number;
            /**
             * Look up an interpolators desired window size.
             */
            vfunc_get_window_size(): number;
            /**
             * the interpolation method
             * @param out write the interpolated pixel here
             * @param _in read source pixels from here
             * @param x interpolate value at this position
             * @param y interpolate value at this position
             */
            vfunc_interpolate(out: any | null, _in: Region, x: number, y: number): void;

            // Methods

            /**
             * Look up an interpolators desired window offset.
             * @returns the interpolators required window offset
             */
            get_window_offset(): number;
            /**
             * Look up an interpolators desired window size.
             * @returns the interpolators required window size
             */
            get_window_size(): number;
        }

        namespace Object {
            // Signal signatures
            interface SignalSignatures extends GObject.Object.SignalSignatures {
                close: () => void;
                postbuild: () => number;
                postclose: () => void;
                preclose: () => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends GObject.Object.ConstructorProps {
                description: string;
                nickname: string;
            }
        }

        /**
         * An abstract base class for all objects in libvips.
         *
         * It has the following major features:
         *
         * - **Functional class creation**: libvips objects have a very regular
         *   lifecycle: initialise, build, use, destroy. They behave rather like
         *   function calls and are free of side-effects.
         *
         * - **Run-time introspection**: libvips objects can be fully introspected
         *   at run-time. There is no need for separate source-code analysis.
         *
         * - **Command-line interface**: Any vips object can be run from the
         *   command-line with the `vips` driver program.
         *
         * ## The [class`Object]` lifecycle
         *
         * [class`Object]`'s have a strictly defined lifecycle, split broadly as
         * construct and then use. In detail, the stages are:
         *
         * 1. [ctor`GObject`.Object.new]. The [class`Object]` is created with
         *   [ctor`GObject`.Object.new]. Objects in this state are blank slates and
         *   need to have their various parameters set.
         *
         * 2. [method`GObject`.Object.set]. You loop over the [struct`Argument]` that
         *   the object has defined with [func`Argument`.map]. Arguments have a set of
         *   flags attached to them for required, optional, input, output, type, and
         *   so on. You must set all required arguments.
         *
         * 3. [method`Object`.build]. Call this to construct the object and get it
         *   ready for use. Building an object happens in four stages, see below.
         *
         * 4. [method`GObject`.Object.get]. The object has now been built. You can
         *   read out any computed values.
         *
         * 5. [method`GObject`.Object.unref]. When you are done with an object, you
         *   can unref it. See the section on reference counting for an explanation
         *   of the convention that [class`Object]` uses. When the last ref to an
         *   object is released, the object is closed. Objects close in three stages,
         *   see below.
         *
         * The stages inside [method`Object`.build] are:
         *
         * 1. Chain up through the object's `build` class methods. At each stage,
         *   each class does any initial setup and checking, then chains up to its
         *   superclass.
         *
         * 2. The innermost `build` method inside [class`Object]` itself checks that
         *   all input arguments have been set and then returns.
         *
         * 3. All object `build` methods now finish executing, from innermost to
         *   outermost. They know all input arguments have been checked and supplied,
         *   so now they set all output arguments.
         *
         * 4. [method`Object`.build] finishes the process by checking that all output
         *   objects have been set, and then triggering the [signal`Object:`:postbuild]
         *   signal. [signal`Object:`:postbuild] only runs if the object has constructed
         *   successfully.
         *
         * [class`Operation]` has a cache of recent operation objects, see that class for
         * an explanation of [func`cache_operation_build]`.
         *
         * Finally, the stages inside close are:
         *
         * 1. [signal`Object:`:preclose]. This is emitted at the start of the
         *   [class`Object]` dispose. The object is still functioning.
         *
         * 2. [signal`Object:`:close]. This runs just after all [struct`Argument]` held
         *   by the object have been released.
         *
         * 3. [signal`Object:`:postclose]. This runs right at the end. The object
         *   pointer is still valid, but nothing else is.
         *
         * ## The [class`Object]` reference counting convention
         *
         * [class`Object]` has a set of conventions to simplify reference counting.
         *
         * 1. All input [class`GObject`.Object] have a ref added to them, owned by the
         *   object. When a [class`Object]` is unreffed, all of these refs to input
         *   objects are automatically dropped.
         *
         * 2. All output [class`GObject`.Object] hold a ref to the object. When a
         *   [class`GObject`.Object] which is an output of a [class`Object]` is
         *   disposed, it must drop this reference. [class`Object]` which are outputs
         *   of other [class`Object]`'s will do this automatically.
         *
         * See [class`Operation]` for an example of [class`Object]` reference counting.
         */
        abstract class Object extends GObject.Object {
            static $gtype: GObject.GType<Object>;

            // Properties

            get description(): string;
            set description(val: string);
            get nickname(): string;
            set nickname(val: string);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Object.SignalSignatures;

            // Fields

            constructed: boolean;
            static_object: boolean;
            argument_table: ArgumentTable;
            close: boolean;
            postclose: boolean;
            local_memory: number;

            // Constructors

            constructor(properties?: Partial<Object.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static new_from_string(object_class: typeof Object, p: string): Object;

            // Signals

            connect<K extends keyof Object.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Object.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Object.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Object.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Object.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Object.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            static get_property(
                gobject: GObject.Object,
                property_id: number,
                value: GObject.Value | any,
                pspec: GObject.ParamSpec,
            ): void;
            static print_all(): void;
            static print_summary_class(klass: typeof Object): void;
            static sanity_all(): void;
            static set_property(
                gobject: GObject.Object,
                property_id: number,
                value: GObject.Value | any,
                pspec: GObject.ParamSpec,
            ): void;
            static install_argument(
                pspec: GObject.ParamSpec,
                flags: ArgumentFlags,
                priority: number,
                offset: number,
            ): void;

            // Virtual methods

            vfunc_build(): number;
            vfunc_close(): void;
            vfunc_output_to_arg(string: string): number;
            vfunc_postbuild(data?: any | null): number;
            vfunc_postclose(): void;
            vfunc_preclose(): void;
            vfunc_rewind(): void;
            vfunc_sanity(buf: Buf): void;
            /**
             * The inverse of [ctor`Object`.new_from_string]: turn `object` into eg.
             * `"VipsInterpolateSnohalo1(blur=.333333)"`.
             * @param buf write string here
             */
            vfunc_to_string(buf: Buf): void;

            // Methods

            /**
             * Convenience: has an argument been assigned. Useful for bindings.
             * @param name arg to fetch
             * @returns `TRUE` if the argument has been assigned.
             */
            argument_isset(name: string): boolean;
            argument_needsstring(name: string): boolean;
            build(): number;
            /**
             * Convenience: get the flags for an argument. Useful for bindings.
             * @param name arg to fetch
             * @returns The [flags@ArgumentFlags] for this argument.
             */
            get_argument_flags(name: string): ArgumentFlags;
            /**
             * Convenience: get the priority for an argument. Useful for bindings.
             * @param name arg to fetch
             * @returns The priority of this argument.
             */
            get_argument_priority(name: string): number;
            get_argument_to_string(name: string, arg: string): number;
            /**
             * Fetch the object description. Useful for language bindings.
             *
             * [property`Object:`description] is only available after `_build()`, which can be too
             * late. This function fetches from the instance, if possible, but falls back
             * to the class description if we are too early.
             * @returns the object description
             */
            get_description(): string;
            local_cb(gobject: GObject.Object): void;
            preclose(): void;
            print_dump(): void;
            print_name(): void;
            print_summary(): void;
            rewind(): void;
            sanity(): boolean;
            set_argument_from_string(name: string, value: string): number;
            /**
             * Set object arguments from a string. The string can be something like
             * "a=12", or "a = 12, b = 13", or "fred". The string can optionally be
             * enclosed in brackets.
             *
             * You'd typically use this between creating the object and building it.
             *
             * ::: seealso
             *     [method`Object`.set], [method`Object`.build],
             *     [func`cache_operation_buildp]`.
             * @param string arguments as a string
             * @returns 0 on success, -1 on error
             */
            set_from_string(string: string): number;
            set_required(value: string): number;
            set_static(static_object: boolean): void;
            /**
             * The inverse of [ctor`Object`.new_from_string]: turn `object` into eg.
             * `"VipsInterpolateSnohalo1(blur=.333333)"`.
             * @param buf write string here
             */
            to_string(buf: Buf): void;
            /**
             * Unref all assigned output objects. Useful for language bindings.
             *
             * After an object is built, all output args are owned by the caller. If
             * something goes wrong before then, we have to unref the outputs that have
             * been made so far. This function can also be useful for callers when
             * they've finished processing outputs themselves.
             *
             * ::: seealso
             *     [func`cache_operation_build]`.
             */
            unref_outputs(): void;
        }

        namespace Operation {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                invalidate: () => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {}
        }

        /**
         * An abstract base class for all operations in libvips.
         *
         * It builds on [class`Object]` to provide the introspection and
         * command-line interface to libvips.
         *
         * It also maintains a cache of recent operations. See below.
         *
         * [func`call]`, [func`call_split]` and [func`call_split_option_string]` are used
         * by vips to implement the C API. They can execute any [class`Operation]`,
         * passing in a set of required and optional arguments. Normally you would not
         * use these functions directly: every operation has a tiny wrapper function
         * which provides type-safety for the required arguments. For example,
         * [method`Image`.embed] is defined as:
         *
         * ```c
         * int
         * vips_embed(VipsImage *in, VipsImage **out,
         *     int x, int y, int width, int height, ...)
         * {
         *     va_list ap;
         *     int result;
         *
         *     va_start(ap, height);
         *     result = vips_call_split("embed", ap, in, out, x, y, width, height);
         *     va_end(ap);
         *
         *     return result;
         * }
         * ```
         *
         * Use [func`call_argv]` to run any libvips operation from a command-line style
         * argc/argv array. This is the thing used by the `vips` main program to
         * implement the command-line interface.
         *
         * ## [class`Operation]` and reference counting
         *
         * After calling a [class`Operation]` you are responsible for unreffing any
         * output objects. For example, consider:
         *
         * ```c
         * VipsImage *im = ...;
         * VipsImage *t1;
         *
         * if (vips_invert(im, &t1, NULL))
         *     error ..
         * ```
         *
         * This will invert `im` and return a new [class`Image]`, `t1`. As the caller
         * of [method`Image`.invert], you are responsible for `t1` and must unref it
         * when you no longer need it. If [method`Image`.invert] fails, no `t1` is
         * returned and you don't need to do anything.
         *
         * If you don't need to use `im` for another operation, you can unref `im`
         * immediately after the call. If `im` is needed to calculate `t1`,
         * [method`Image`.invert] will add a ref to `im` and automatically drop it when
         * `t1` is unreffed.
         *
         * Consider running two operations, one after the other. You could write:
         *
         * ```c
         * VipsImage *im = ...;
         * VipsImage *t1, *t2;
         *
         * if (vips_invert(im, &t1, NULL)) {
         *     g_object_unref(im);
         *     return -1;
         * }
         * g_object_unref(im);
         *
         * if (vips_flip(t1, &t2, VIPS_DIRECTION_HORIZONTAL, NULL)) {
         *     g_object_unref(t1);
         *     return -1;
         * }
         * g_object_unref(t1);
         * ```
         *
         * This is correct, but rather long-winded. libvips provides a handy thing to
         * make a vector of auto-freeing object references. You can write this as:
         *
         * ```c
         * VipsObject *parent = ...;
         * VipsImage *im = ...;
         * VipsImage *t = (VipsImage **) vips_object_local_array(parent, 2);
         *
         * if (vips_invert(im, &t[0], NULL) ||
         *     vips_flip(t[0], &t[1], VIPS_DIRECTION_HORIZONTAL, NULL))
         *     return -1;
         * ```
         *
         * where `parent` is some enclosing object which will be unreffed when this
         * task is complete. [method`Object`.local_array] makes an array of
         * [class`Object]` (or [class`Image]`, in this case) where when `parent` is
         * freed, all non-`NULL` [class`Object]` in the array are also unreffed.
         *
         * ## The [class`Operation]` cache
         *
         * Because all [class`Object]` are immutable, they can be cached. The cache is
         * very simple to use: instead of calling [method`Object`.build], call
         * [func`cache_operation_build]`. This function calculates a hash from the
         * operations' input arguments and looks it up in table of all recent
         * operations. If there's a hit, the new operation is unreffed, the old
         * operation reffed, and the old operation returned in place of the new one.
         *
         * The cache size is controlled with [func`cache_set_max]` and friends.
         */
        abstract class Operation extends Object {
            static $gtype: GObject.GType<Operation>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Operation.SignalSignatures;

            // Fields

            hash: number;
            found_hash: boolean;
            pixels: number;

            // Constructors

            constructor(properties?: Partial<Operation.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](name: string): Operation;

            // Signals

            connect<K extends keyof Operation.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Operation.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Operation.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Operation.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Operation.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Operation.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            /**
             * Set the block state on all operations in the libvips class hierarchy at
             * `name` and below.
             *
             * For example:
             *
             * ```c
             * vips_operation_block_set("VipsForeignLoad", TRUE);
             * vips_operation_block_set("VipsForeignLoadJpeg", FALSE);
             * ```
             *
             * Will block all load operations, except JPEG.
             *
             * Use `vips -l` at the command-line to see the class hierarchy.
             *
             * This call does nothing if the named operation is not found.
             *
             * ::: seealso
             *     [func`block_untrusted_set]`.
             * @param name set block state at this point and below
             * @param state the block state to set
             */
            static block_set(name: string, state: boolean): void;

            // Virtual methods

            /**
             * Returns the set of flags for this operation.
             */
            vfunc_get_flags(): OperationFlags;
            vfunc_invalidate(): void;

            // Methods

            /**
             * Returns the set of flags for this operation.
             * @returns 0 on success, or -1 on error.
             */
            get_flags(): OperationFlags;
            invalidate(): void;
        }

        namespace Region {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {}
        }

        /**
         * A [class`Region]` represents a small, rectangular part of an image.
         *
         * You use regions to read pixels out of images without having to have the
         * whole image in memory at once.
         *
         * A region can be a memory buffer, part of a memory-mapped file, part of some
         * other image, or part of some other region.
         *
         * Regions must be created, used and freed all within the same thread, since
         * they can reference private per-thread caches. libvips sanity-checks region
         * ownership in various places, so you are likely to see [func`GLib`.assert]
         * errors if you don't follow this rule.
         *
         * There is API to transfer ownership of regions between threads, but
         * (hopefully) this is only needed within libvips, so we don't expose it.
         */
        class Region extends Object {
            static $gtype: GObject.GType<Region>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Region.SignalSignatures;

            // Fields

            parent_object: Object;
            im: Image;
            valid: Rect;

            // Constructors

            constructor(properties?: Partial<Region.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](image: Image): Region;

            // Signals

            connect<K extends keyof Region.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Region.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Region.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Region.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Region.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Region.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Methods

            /**
             * Paints 0 into the valid part of `reg`.
             *
             * ::: seealso
             *     [method`Region`.paint].
             */
            black(): void;
            /**
             * The region is transformed so that at least `r` pixels are available as a
             * memory buffer that can be written to.
             * @param r [struct@Rect] of pixels you need to be able to address
             * @returns 0 on success, or -1 for error.
             */
            buffer(r: Rect): number;
            /**
             * Copy from one region to another. Copy area `r` from inside `reg` to `dest,`
             * positioning the area of pixels at `x,` `y`. The two regions must have pixels
             * which are the same size.
             *
             * ::: seealso
             *     [method`Region`.paint].
             * @param dest destination region
             * @param r [struct@Rect] of pixels you need to copy
             * @param x position of @r in @dest
             * @param y position of @r in @dest
             */
            copy(dest: Region, r: Rect, x: number, y: number): Region;
            /**
             * Do two regions point to the same piece of image? ie.
             *
             * ```c
             * VIPS_REGION_ADDR(reg1, x, y) == VIPS_REGION_ADDR(reg2, x, y) &&
             * *VIPS_REGION_ADDR(reg1, x, y) ==
             *     *VIPS_REGION_ADDR(reg2, x, y) for all x, y, reg1, reg2.
             * ```
             * @param reg2 region to test
             * @returns non-zero on equality.
             */
            equalsregion(reg2: Region): number;
            /**
             * Generate an area of pixels and return a copy. The result must be freed
             * with [func`GLib`.free]. The requested area must be completely inside the
             * image.
             *
             * This is equivalent to [method`Region`.prepare], followed by a memcpy. It is
             * convenient for language bindings.
             * @param left area of pixels to fetch
             * @param top area of pixels to fetch
             * @param width area of pixels to fetch
             * @param height area of pixels to fetch
             * @param len
             * @returns A copy of the pixel data.
             */
            fetch(left: number, top: number, width: number, height: number, len: number): Pel;
            height(): number;
            /**
             * The region is transformed so that at least `r` pixels are available to be
             * read from the image. The image needs to be a memory buffer or represent a
             * file on disc that has been mapped or can be mapped.
             * @param r [struct@Rect] of pixels you need to be able to address
             * @returns 0 on success, or -1 for error.
             */
            image(r: Rect): number;
            /**
             * Mark a region as containing invalid pixels. Calling this function means
             * that the next time [method`Region`.prepare] is called, the region will be
             * recalculated.
             *
             * This is faster than calling [method`Image`.invalidate_all], but obviously only
             * affects a single region.
             *
             * ::: seealso
             *     [method`Image`.invalidate_all], [method`Region`.prepare].
             */
            invalidate(): void;
            /**
             * Paints `value` into `reg` covering rectangle `r`.
             * `r` is clipped against
             * `reg->`valid.
             *
             * For int images, `value` is
             * passed to [`memset()`](man:memset(3)), so it usually needs to be 0 or 255. For float images,
             * value is cast to a float and copied in to each band element.
             *
             * `r` is clipped against
             * `reg->`valid.
             *
             * ::: seealso
             *     [method`Region`.black].
             * @param r area to paint
             * @param value value to paint
             */
            paint(r: Rect, value: number): void;
            /**
             * Paints `ink` into `reg` covering rectangle `r`. `r` is clipped against
             * `reg->`valid.
             *
             * `ink` should be a byte array of the same size as an image pixel containing
             * the binary value to write into the pixels.
             *
             * ::: seealso
             *     [method`Region`.paint].
             * @param r area to paint
             * @param ink value to paint
             */
            paint_pel(r: Rect, ink: Pel): void;
            /**
             * Set the position of a region. This only affects reg->valid, ie. the way
             * pixels are addressed, not reg->data, the pixels which are addressed. Clip
             * against the size of the image. Do not allow negative positions, or
             * positions outside the image.
             * @param x position to move to
             * @param y position to move to
             * @returns 0 on success, or -1 for error.
             */
            position(x: number, y: number): number;
            /**
             * [method`Region`.prepare] fills `reg` with pixels. After calling,
             * you can address at least the area `r` with [func`REGION_ADDR]` and get
             * valid pixels.
             *
             * [method`Region`.prepare] runs in-line, that is, computation is done by
             * the calling thread, no new threads are involved, and computation
             * blocks until the pixels are ready.
             *
             * Use [method`Image`.sink_screen] to calculate an area of pixels in the
             * background.
             *
             * ::: seealso
             *     [method`Image`.sink_screen], [method`Region`.prepare_to].
             * @param r [struct@Rect] of pixels you need to be able to address
             * @returns 0 on success, or -1 on error.
             */
            prepare(r: Rect): number;
            /**
             * Like [method`Region`.prepare]: fill `reg` with the pixels in area `r`.
             *
             * Unlike [method`Region`.prepare], rather than writing the result to `reg,` the
             * pixels are written into `dest` at offset `x,` `y`.
             *
             * Also unlike [method`Region`.prepare], `dest` is not set up for writing for
             * you with [method`Region`.buffer]. You can
             * point `dest` at anything, and pixels really will be written there.
             * This makes [method`Region`.prepare_to] useful for making the ends of
             * pipelines.
             *
             * ::: seealso
             *     [method`Region`.prepare], [method`Image`.sink_disc].
             * @param dest region to write to
             * @param r [struct@Rect] of pixels you need to be able to address
             * @param x position of @r in @dest
             * @param y position of @r in @dest
             * @returns 0 on success, or -1 on error
             */
            prepare_to(dest: Region, r: Rect, x: number, y: number): number;
            /**
             * Make [func`REGION_ADDR]` on `reg` go to `dest` instead.
             *
             * `r` is the part of `reg` which you want to be able to address (this
             * effectively becomes the valid field), (`x,` `y)` is the top LH corner of the
             * corresponding area in `dest`.
             *
             * Performs all clipping necessary to ensure that `reg->`valid is indeed
             * valid.
             *
             * If the region we attach to is moved or destroyed, we can be left with
             * dangling pointers! If the region we attach to is on another image, the
             * two images must have the same sizeof(pel).
             * @param dest region to connect to
             * @param r [struct@Rect] of pixels you need to be able to address
             * @param x position of @r in @dest
             * @param y position of @r in @dest
             * @returns 0 on success, or -1 for error.
             */
            region(dest: Region, r: Rect, x: number, y: number): number;
            /**
             * Write the pixels `target` in `to` from the x2 larger area in `from`.
             * Non-complex uncoded images and LABQ only. Images with alpha (see
             * [method`Image`.hasalpha]) shrink with pixels scaled by alpha to avoid
             * fringing.
             *
             * `method` selects the method used to do the 2x2 shrink.
             *
             * ::: seealso
             *     [method`Region`.copy].
             * @param to destination region
             * @param target [struct@Rect] of pixels you need to copy
             * @param method method to use when generating target pixels
             */
            shrink_method(to: Region, target: Rect, method: RegionShrink | null): [number, Region];
            width(): number;
        }

        namespace Sbuf {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                'notify::input': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {
                input: Source;
            }
        }

        /**
         * A [class`Sbuf]` provides a buffered reading interface for a [class`Source]`.
         *
         * You can fetch lines of text, skip whitespace, and so on.
         *
         * It is useful for implementing things like CSV readers, for example.
         */
        class Sbuf extends Object {
            static $gtype: GObject.GType<Sbuf>;

            // Properties

            get input(): Source;
            set input(val: Source);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Sbuf.SignalSignatures;

            // Fields

            parent_object: Object;

            // Constructors

            constructor(properties?: Partial<Sbuf.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static new_from_source(source: Source): Sbuf;

            // Signals

            connect<K extends keyof Sbuf.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Sbuf.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Sbuf.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Sbuf.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Sbuf.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Sbuf.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Methods

            /**
             * Fetch the next line of text from `sbuf` and return it. The end of
             * line character (or characters, for DOS files) are removed, and the string
             * is terminated with a null (`\0` character).
             *
             * Returns `NULL` on end of file or read error.
             *
             * If the line is longer than some arbitrary (but large) limit, it is
             * truncated. If you need to be able to read very long lines, use the
             * slower [method`Sbuf`.get_line_copy].
             *
             * The return value is owned by `sbuf` and must not be freed. It
             * is valid until the next get call to `sbuf`.
             * @returns the next line of text, or `NULL` on EOF or read error.
             */
            get_line(): string;
            /**
             * Fetch the next line of text from `sbuf` and return it. The end of
             * line character (or characters, for DOS files) are removed, and the string
             * is terminated with a null (`\0` character).
             *
             * The return result must be freed with [func`GLib`.free].
             *
             * This is slower than [method`Sbuf`.get_line], but can work with lines of
             * any length.
             * @returns the next line of text, or `NULL` on EOF or read error.
             */
            get_line_copy(): string;
            /**
             * Fetch the next chunk of non-whitespace text from the source, and
             * null-terminate it.
             *
             * After this, the next getc will be the first char of the next block of
             * whitespace (or EOF).
             *
             * If the first getc is whitespace, stop instantly and return the empty
             * string.
             *
             * If the item is longer than some arbitrary (but large) limit, it is
             * truncated.
             *
             * The return value is owned by `sbuf` and must not be freed. It
             * is valid until the next get call to `sbuf`.
             * @returns the next block of non-whitespace, or `NULL` on EOF or read error.
             */
            get_non_whitespace(): string;
            /**
             * Fetch the next character from the source.
             *
             * If you can, use the macro [func`SBUF_GETC]` instead for speed.
             * @returns the next char from @sbuf, -1 on read error or EOF.
             */
            getc(): number;
            /**
             * Make sure there are at least `require` bytes of readahead available.
             * @param require make sure we have at least this many chars available
             * @returns 0 on success, -1 on error or EOF.
             */
            require(require: number): number;
            /**
             * After this, the next getc will be the first char of the next block of
             * non-whitespace (or EOF).
             *
             * Also skip comments, ie. from any '#' character to the end of the line.
             * @returns 0 on success, or -1 on EOF.
             */
            skip_whitespace(): number;
            /**
             * Discard the input buffer and reset the read point. You must call this
             * before using read or seek on the underlying [class`Source]` class.
             */
            unbuffer(): void;
            /**
             * The opposite of [method`Sbuf`.getc]: undo the previous getc.
             *
             * unget more than one character is undefined. Unget at the start of the file
             * does nothing.
             *
             * If you can, use the macro [func`SBUF_UNGETC]` instead for speed.
             */
            ungetc(): void;
        }

        namespace Source {
            // Signal signatures
            interface SignalSignatures extends Connection.SignalSignatures {
                'notify::blob': (pspec: GObject.ParamSpec) => void;
                'notify::descriptor': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Connection.ConstructorProps {
                blob: Blob;
            }
        }

        /**
         * A [class`Source]` provides a unified interface for reading, seeking, and
         * mapping data, regardless of the underlying source type.
         *
         * This source can originate from something like a socket, file or memory
         * area.
         *
         * During the header phase, we save data from unseekable sources in a buffer
         * so readers can rewind and read again. We don't buffer data during the
         * decode stage.
         */
        class Source extends Connection {
            static $gtype: GObject.GType<Source>;

            // Properties

            get blob(): Blob;
            set blob(val: Blob);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Source.SignalSignatures;

            // Fields

            parent_object: Connection;
            have_tested_seek: boolean;
            is_pipe: boolean;
            read_position: number;

            // Constructors

            constructor(properties?: Partial<Source.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static new_from_blob(blob: Blob): Source;

            static new_from_descriptor(descriptor: number): Source;

            static new_from_file(filename: string): Source;

            static new_from_memory(data: any | null, length: number): Source;

            static new_from_options(options: string): Source;

            static new_from_target(target: Target): Source;

            // Signals

            connect<K extends keyof Source.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Source.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Source.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Source.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Source.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Source.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            /**
             * Create a [struct`SourceGInputStream]` which wraps `stream`.
             *
             * ::: seealso
             *     [func`g_input_stream_new_from_source]`
             * @param stream read from this stream
             */
            static g_input_stream_new(stream: Gio.InputStream): SourceGInputStream;

            // Virtual methods

            /**
             * Read up to `length` bytes from `source` and store the bytes in `buffer`.
             * Return the number of bytes actually read. If all bytes have been read from
             * the file, return 0.
             *
             * Arguments exactly as [`read()`](man:read(2)).
             * @param buffer store bytes here
             * @param length length of @buffer in bytes
             */
            vfunc_read(buffer: any | null, length: number): number;
            /**
             * Move the file read position. You can't call this after pixel decode starts.
             * The arguments are exactly as [`lseek()`](man:lseek(2)).
             * @param offset seek by this offset
             * @param whence seek relative to this point
             */
            vfunc_seek(offset: number, whence: number): number;

            // Methods

            /**
             * Signal the end of header read and the start of the pixel decode phase.
             * After this, you can no longer seek on this source.
             *
             * Loaders should call this at the end of header read.
             *
             * ::: seealso
             *     [method`Source`.unminimise].
             * @returns 0 on success, -1 on error.
             */
            decode(): number;
            /**
             * Test if this source is a simple file with support for seek. Named pipes,
             * for example, will fail this test. If `TRUE`, you can use
             * [method`Connection`.filename] to find the filename.
             *
             * Use this to add basic source support for older loaders which can only work
             * on files.
             * @returns `TRUE` if the source is a simple file.
             */
            is_file(): boolean;
            /**
             * Some sources can be efficiently mapped into memory.
             * You can still use [method`Source`.map] if this function returns `FALSE`,
             * but it will be slow.
             * @returns `TRUE` if the source can be efficiently mapped into memory.
             */
            is_mappable(): boolean;
            /**
             * Return the length in bytes of the source. Unseekable sources, for
             * example pipes, will have to be read entirely into memory before the length
             * can be found, so this operation can take a long time.
             * @returns number of bytes in source, or -1 on error.
             */
            length(): number;
            /**
             * Map the source entirely into memory and return a pointer to the
             * start. If `length` is non-NULL, the source size is written to it.
             *
             * This operation can take a long time. Use [method`Source`.is_mappable] to
             * check if a source can be mapped efficiently.
             *
             * The pointer is valid for as long as `source` is alive.
             * @param length return the file length here, or `NULL`
             * @returns a pointer to the start of the file contents, or `NULL` on error.
             */
            map(length: number): any | null;
            /**
             * Just like [method`Source`.map], but return a [struct`Blob]` containing the
             * pointer. `source` will stay alive as long as the result is alive.
             * @returns a new [struct@Blob] containing the data, or `NULL` on error.
             */
            map_blob(): Blob;
            /**
             * Minimise the source. As many resources as can be safely removed are
             * removed. Use [method`Source`.unminimise] to restore the source if you wish to
             * use it again.
             *
             * Loaders should call this in response to the minimise signal on their output
             * image.
             */
            minimise(): void;
            /**
             * Read up to `length` bytes from `source` and store the bytes in `buffer`.
             * Return the number of bytes actually read. If all bytes have been read from
             * the file, return 0.
             *
             * Arguments exactly as [`read()`](man:read(2)).
             * @param buffer store bytes here
             * @param length length of @buffer in bytes
             * @returns the number of bytes read, 0 on end of file, -1 on error.
             */
            read(buffer: any | null, length: number): number;
            /**
             * Rewind the source to the start.
             *
             * You can't always do this after the pixel decode phase starts -- for
             * example, pipe-like sources can't be rewound.
             * @returns 0 on success, or -1 on error.
             */
            rewind(): number;
            // Conflicted with Vips.Object.rewind
            rewind(...args: never[]): any;
            /**
             * Move the file read position. You can't call this after pixel decode starts.
             * The arguments are exactly as [`lseek()`](man:lseek(2)).
             * @param offset seek by this offset
             * @param whence seek relative to this point
             * @returns the new file position, or -1 on error.
             */
            seek(offset: number, whence: number): number;
            /**
             * Return a pointer to the first few bytes of the file. If the file is too
             * short, return `NULL`.
             * @param length number of bytes to sniff
             * @returns a pointer to the bytes at the start of the file, or `NULL` on error.
             */
            sniff(length: number): number;
            /**
             * Attempt to sniff at most `length` bytes from the start of the source. A
             * pointer to the bytes is returned in `data`. The number of bytes actually
             * read is returned -- it may be less than `length` if the file is shorter than
             * `length`. A negative number indicates a read error.
             * @param data return a pointer to the bytes read here
             * @param length max number of bytes to read
             * @returns number of bytes read, or -1 on error.
             */
            sniff_at_most(data: number, length: number): number;
            /**
             * Restore the source after minimisation. This is called at the start
             * of every source method, so loaders should not usually need this.
             *
             * ::: seealso
             *     [method`Source`.minimise].
             * @returns 0 on success, or -1 on error.
             */
            unminimise(): number;
        }

        namespace SourceCustom {
            // Signal signatures
            interface SignalSignatures extends Source.SignalSignatures {
                read: (arg0: any | null, arg1: number) => number;
                seek: (arg0: number, arg1: number) => number;
                'notify::blob': (pspec: GObject.ParamSpec) => void;
                'notify::descriptor': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Source.ConstructorProps {}
        }

        /**
         * Subclass of [class`Source]` with action signals for handlers.
         *
         * This is supposed to be useful for language bindings.
         */
        class SourceCustom extends Source {
            static $gtype: GObject.GType<SourceCustom>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: SourceCustom.SignalSignatures;

            // Fields

            parent_object: Source;

            // Constructors

            constructor(properties?: Partial<SourceCustom.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](): SourceCustom;

            // Signals

            connect<K extends keyof SourceCustom.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, SourceCustom.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof SourceCustom.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, SourceCustom.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof SourceCustom.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<SourceCustom.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Virtual methods

            vfunc_read(buffer: any | null, length: number): number;
            vfunc_seek(offset: number, whence: number): number;
        }

        namespace Target {
            // Signal signatures
            interface SignalSignatures extends Connection.SignalSignatures {
                'notify::blob': (pspec: GObject.ParamSpec) => void;
                'notify::memory': (pspec: GObject.ParamSpec) => void;
                'notify::descriptor': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Connection.ConstructorProps {
                blob: Blob;
                memory: boolean;
            }
        }

        /**
         * A [class`Target]` provides a unified interface for writing data to various
         * output destinations.
         *
         * This target could be a socket, file, memory area, or any other destination
         * that accepts byte data.
         */
        class Target extends Connection {
            static $gtype: GObject.GType<Target>;

            // Properties

            get blob(): Blob;
            set blob(val: Blob);
            get memory(): boolean;
            set memory(val: boolean);

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: Target.SignalSignatures;

            // Fields

            parent_object: Connection;

            // Constructors

            constructor(properties?: Partial<Target.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static new_temp(based_on: Target): Target;

            static new_to_descriptor(descriptor: number): Target;

            static new_to_file(filename: string): Target;

            static new_to_memory(): Target;

            // Signals

            connect<K extends keyof Target.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Target.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof Target.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, Target.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof Target.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<Target.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Virtual methods

            /**
             * Call this at the end of write to make the target do any cleaning up. You
             * can call it many times.
             *
             * After a target has been ended, further writes will do nothing.
             */
            vfunc_end(): number;
            vfunc_finish(): void;
            /**
             * Read up to `length` bytes from `target` and store the bytes in `buffer`.
             * Return the number of bytes actually read. If all bytes have been read from
             * the file, return 0.
             *
             * Arguments exactly as [`read()`](man:read(2)).
             *
             * Reading from a target sounds weird, but libtiff needs this for
             * multi-page writes. This method will fail for targets like pipes.
             * @param buffer store bytes here
             * @param length length of @buffer in bytes
             */
            vfunc_read(buffer: any | null, length: number): number;
            /**
             * Seek the target. This behaves exactly as [`lseek()`](man:lseek(2)).
             *
             * Seeking a target sounds weird, but libtiff needs this. This method will
             * fail for targets like pipes.
             * @param offset offset to seek to
             * @param whence seek relative to beginning, offset, or end
             */
            vfunc_seek(offset: number, whence: number): number;
            vfunc_write(data: any | null, length: number): number;

            // Methods

            /**
             * Call this at the end of write to make the target do any cleaning up. You
             * can call it many times.
             *
             * After a target has been ended, further writes will do nothing.
             * @returns 0 on success, -1 on error.
             */
            end(): number;
            /**
             * Write a single character `ch` to `target`. See the macro [func`TARGET_PUTC]`
             * for a faster way to do this.
             * @param ch character to write
             * @returns 0 on success, -1 on error.
             */
            putc(ch: number): number;
            /**
             * Read up to `length` bytes from `target` and store the bytes in `buffer`.
             * Return the number of bytes actually read. If all bytes have been read from
             * the file, return 0.
             *
             * Arguments exactly as [`read()`](man:read(2)).
             *
             * Reading from a target sounds weird, but libtiff needs this for
             * multi-page writes. This method will fail for targets like pipes.
             * @param buffer store bytes here
             * @param length length of @buffer in bytes
             * @returns the number of bytes read, 0 on end of file, -1 on error.
             */
            read(buffer: any | null, length: number): number;
            /**
             * Seek the target. This behaves exactly as [`lseek()`](man:lseek(2)).
             *
             * Seeking a target sounds weird, but libtiff needs this. This method will
             * fail for targets like pipes.
             * @param offset offset to seek to
             * @param whence seek relative to beginning, offset, or end
             * @returns the new offset, -1 on error.
             */
            seek(offset: number, whence: number): number;
            /**
             * Memory targets only (see [ctor`Target`.new_to_memory]). Steal all data
             * written to the target so far, and call [method`Target`.end].
             *
             * You must free the returned pointer with [func`GLib`.free].
             *
             * The data is NOT automatically null-terminated. Use [method`Target`.putc] with
             * a '\0' before calling this to get a null-terminated string.
             *
             * You can't call this after [method`Target`.end], since that moves the data to a
             * blob, and we can't steal from that in case the pointer has been shared.
             *
             * You can't call this function more than once.
             * @returns the data
             */
            steal(): Uint8Array;
            /**
             * As [method`Target`.steal], but return a null-terminated string.
             * @returns target contents as a null-terminated string.
             */
            steal_text(): string;
            /**
             * Write `length` bytes from `data` to the output.
             * @param data data to write
             * @param length length of @data in bytes
             * @returns 0 on success, -1 on error.
             */
            write(data: any | null, length: number): number;
            /**
             * Write `str` to `target,` but escape stuff that xml hates in text. Our
             * argument string is utf-8.
             *
             * XML rules:
             *
             * - We must escape &<>
             * - Don't escape \n, \t, \r
             * - Do escape the other ASCII codes.
             * @param str string to write
             * @returns 0 on success, -1 on error.
             */
            write_amp(str: string): number;
            /**
             * Write a null-terminated string to `target`.
             * @param str string to write
             * @returns 0 on success, and -1 on error.
             */
            writes(str: string): number;
        }

        namespace TargetCustom {
            // Signal signatures
            interface SignalSignatures extends Target.SignalSignatures {
                end: () => number;
                finish: () => void;
                read: (arg0: any | null, arg1: number) => number;
                seek: (arg0: number, arg1: number) => number;
                write: (arg0: any | null, arg1: number) => number;
                'notify::blob': (pspec: GObject.ParamSpec) => void;
                'notify::memory': (pspec: GObject.ParamSpec) => void;
                'notify::descriptor': (pspec: GObject.ParamSpec) => void;
                'notify::filename': (pspec: GObject.ParamSpec) => void;
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Target.ConstructorProps {}
        }

        /**
         * Subclass of [class`Target]` with action signals for handlers.
         *
         * This is supposed to be useful for language bindings.
         */
        class TargetCustom extends Target {
            static $gtype: GObject.GType<TargetCustom>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: TargetCustom.SignalSignatures;

            // Fields

            parent_object: Target;

            // Constructors

            constructor(properties?: Partial<TargetCustom.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](): TargetCustom;

            // Signals

            connect<K extends keyof TargetCustom.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, TargetCustom.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof TargetCustom.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, TargetCustom.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof TargetCustom.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<TargetCustom.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Virtual methods

            vfunc_end(): number;
            vfunc_finish(): void;
            vfunc_read(buffer: any | null, length: number): number;
            vfunc_seek(offset: number, whence: number): number;
            vfunc_write(data: any | null, length: number): number;
        }

        namespace ThreadState {
            // Signal signatures
            interface SignalSignatures extends Object.SignalSignatures {
                'notify::description': (pspec: GObject.ParamSpec) => void;
                'notify::nickname': (pspec: GObject.ParamSpec) => void;
            }

            // Constructor properties interface

            interface ConstructorProps extends Object.ConstructorProps {}
        }

        /**
         * A [class`ThreadState]` represents a per-thread state.
         *
         * [callback`ThreadpoolAllocateFn]` functions can use these members to
         * communicate with [callback`ThreadpoolWorkFn]` functions.
         *
         * ::: seealso
         *     [func`threadpool_run]`.
         */
        class ThreadState extends Object {
            static $gtype: GObject.GType<ThreadState>;

            /**
             * Compile-time signal type information.
             *
             * This instance property is generated only for TypeScript type checking.
             * It is not defined at runtime and should not be accessed in JS code.
             * @internal
             */
            $signals: ThreadState.SignalSignatures;

            // Fields

            parent_object: Object;
            im: Image;
            reg: Region;
            pos: Rect;
            x: number;
            y: number;
            stop: boolean;
            a: any;
            stall: boolean;

            // Constructors

            constructor(properties?: Partial<ThreadState.ConstructorProps>, ...args: any[]);

            _init(...args: any[]): void;

            static ['new'](im: Image, a?: any | null): ThreadState;

            // Signals

            connect<K extends keyof ThreadState.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ThreadState.SignalSignatures[K]>,
            ): number;
            connect(signal: string, callback: (...args: any[]) => any): number;
            connect_after<K extends keyof ThreadState.SignalSignatures>(
                signal: K,
                callback: GObject.SignalCallback<this, ThreadState.SignalSignatures[K]>,
            ): number;
            connect_after(signal: string, callback: (...args: any[]) => any): number;
            emit<K extends keyof ThreadState.SignalSignatures>(
                signal: K,
                ...args: GObject.GjsParameters<ThreadState.SignalSignatures[K]> extends [any, ...infer Q] ? Q : never
            ): void;
            emit(signal: string, ...args: any[]): void;

            // Static methods

            static set(object: Object, a?: any | null, b?: any | null): any | null;
        }

        class Area {
            static $gtype: GObject.GType<Area>;

            // Fields

            data: any;
            length: number;
            n: number;

            // Constructors

            constructor(free_fn?: CallbackFn | null);
            _init(...args: any[]): void;

            static ['new'](free_fn?: CallbackFn | null): Area;

            static new_array(type: GObject.GType, sizeof_type: number, n: number): Area;

            static new_array_object(n: number): Area;

            // Static methods

            static free_cb(mem: any | null, area: Area): number;

            // Methods

            copy(): Area;
            /**
             * Return the data pointer plus optionally the length in bytes of an area,
             * the number of elements, the [alias`GObject`.Type] of each element and the
             * `sizeof()` each element.
             * @returns The pointer held by @area.
             */
            get_data(): [any | null, number, number, GObject.GType | null, number];
            unref(): void;
        }

        /**
         * libvips has a simple mechanism for automating at least some aspects of
         * [class`GObject`.Object] properties. You add a set of macros to your
         * `_class_init()` which describe the arguments, and set the get and set
         * functions to the libvips ones.
         *
         * See [extending](extending.html) for a complete example.
         */
        class Argument {
            static $gtype: GObject.GType<Argument>;

            // Fields

            pspec: GObject.ParamSpec;

            // Constructors

            _init(...args: any[]): void;

            // Static methods

            /**
             * Loop over the [struct`Argument]` of an object. Stop when `fn` returns non-`NULL`
             * and return that value.
             * @param object object whose args should be enumerated
             * @param fn call this function for every argument
             * @param b client data
             */
            static map(object: Object, fn: ArgumentMapFn, b?: any | null): any | null;
        }

        class ArgumentClass {
            static $gtype: GObject.GType<ArgumentClass>;

            // Fields

            flags: ArgumentFlags;
            priority: number;
            offset: number;

            // Constructors

            _init(...args: any[]): void;

            // Methods

            needsstring(): boolean;
        }

        class ArgumentInstance {
            static $gtype: GObject.GType<ArgumentInstance>;

            // Fields

            object: Object;
            assigned: boolean;
            close_id: number;
            invalidate_id: number;

            // Constructors

            _init(...args: any[]): void;
        }

        class ArrayDouble {
            static $gtype: GObject.GType<ArrayDouble>;

            // Constructors

            constructor(array: number[]);
            _init(...args: any[]): void;

            static ['new'](array: number[]): ArrayDouble;

            // Methods

            /**
             * Fetch a double array from a [struct`ArrayDouble]`. Useful for language bindings.
             * @returns array of double
             */
            get(): number[];
        }

        class ArrayImage {
            static $gtype: GObject.GType<ArrayImage>;

            // Constructors

            constructor(
                properties?: Partial<{
                    area: Area;
                }>,
            );
            _init(...args: any[]): void;

            static empty(): ArrayImage;

            static ['new'](array: Image[]): ArrayImage;

            static new_from_string(string: string, flags: Access): ArrayImage;

            // Methods

            /**
             * Make a new [struct`ArrayImage]`, one larger than `array,` with `image` appended
             * to the end.
             * Handy with [ctor`ArrayImage`.empty] for bindings
             * which can't handle object array arguments.
             *
             * ::: seealso
             *     [ctor`ArrayImage`.empty].
             * @param image add this
             * @returns A new [struct@ArrayImage].
             */
            append(image: Image): ArrayImage;
            /**
             * Fetch an image array from a [struct`ArrayImage]`. Useful for language bindings.
             * @returns array of [class@Image]
             */
            get(): Image[];
        }

        class ArrayInt {
            static $gtype: GObject.GType<ArrayInt>;

            // Constructors

            constructor(array: number[]);
            _init(...args: any[]): void;

            static ['new'](array: number[]): ArrayInt;

            // Methods

            /**
             * Fetch an int array from a [struct`ArrayInt]`. Useful for language bindings.
             * @returns array of int
             */
            get(): number[];
        }

        class Blob {
            static $gtype: GObject.GType<Blob>;

            // Constructors

            constructor(free_fn: CallbackFn | null, data: Uint8Array | string);
            _init(...args: any[]): void;

            static ['new'](free_fn: CallbackFn | null, data: Uint8Array | string): Blob;

            // Static methods

            /**
             * Like [ctor`Blob`.new], but take a copy of the data. Useful for bindings
             * which struggle with callbacks.
             *
             * ::: seealso
             *     [ctor`Blob`.new].
             * @param data data to store
             */
            static copy(data: Uint8Array | string): Blob;

            // Methods

            /**
             * Get the data from a [struct`Blob]`.
             *
             * ::: seealso
             *     [ctor`Blob`.new].
             * @returns the data
             */
            get(): Uint8Array;
            /**
             * Any old data is freed and new data attached.
             *
             * It's sometimes useful to be able to create blobs as empty and then fill
             * them later.
             *
             * ::: seealso
             *     [ctor`Blob`.new].
             * @param free_fn @data will be freed with this function
             * @param data data to store
             */
            set(free_fn: CallbackFn | null, data: Uint8Array | string): void;
        }

        /**
         * A message buffer you can append stuff to safely and quickly. If the message
         * gets too long, you get "..." and truncation. Message buffers can be on the
         * stack or heap.
         *
         * For example:
         *
         * ```c
         * char txt[256];
         * VipsBuf buf = VIPS_BUF_STATIC(txt);
         * int i;
         *
         * vips_buf_appends(&buf, "Numbers are: ");
         * for (i = 0; i < array_length; i++) {
         *     if (i > 0)
         *         vips_buf_appends(&buf, ", ");
         *     vips_buf_appendg(&buf, array[i]);
         * }
         * printf("%s", vips_buf_all(&buf));
         * ```
         */
        class Buf {
            static $gtype: GObject.GType<Buf>;

            // Constructors

            constructor(properties?: Partial<{}>);
            _init(...args: any[]): void;

            // Methods

            /**
             * Return the contents of the buffer as a C string.
             * @returns the `NULL`-terminated contents of the buffer. This is a pointer to the memory managed by the buffer and must not be freed.
             */
            all(): string;
            /**
             * Turn a number of bytes into a sensible string ... eg "12", "12KB", "12MB",
             * "12GB" etc.
             * @param n the number of bytes
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            append_size(n: number): boolean;
            /**
             * Append a single character `ch` to `buf`.
             * @param ch the character to append to the buffer
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appendc(ch: number): boolean;
            /**
             * Append a number. If the number is -ve, add brackets. Needed for
             * building function arguments.
             * @param d value to format and append
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appendd(d: number): boolean;
            /**
             * Append a double, non-localised. Useful for config files etc.
             * @param g value to format and append
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appendg(g: number): boolean;
            /**
             * Format and append a [struct`GObject`.Value] as a printable thing.
             * We display text like "3144 bytes of binary data" for BLOBs like icc-profile-data.
             *
             * Use [method`Image`.get_as_string] to make a text representation of a field.
             * That will base64-encode blobs, for example.
             * @param value [struct@GObject.Value] to format and append
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appendgv(value: GObject.Value | any): boolean;
            /**
             * Append at most `sz` chars from `str` to `buf`. `sz` < 0 means unlimited. This
             * is the low-level append operation: functions like [method`Buf`.appendf] build
             * on top of this.
             * @param str the string to append to the buffer
             * @param sz the size of the string to append
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appendns(str: string, sz: number): boolean;
            /**
             * Append the whole of `str` to `buf`.
             * @param str the string to append to the buffer
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            appends(str: string): boolean;
            /**
             * Swap the rightmost occurrence of `o` for `n`.
             * @param o the string to search for
             * @param n the string to substitute
             * @returns `FALSE` on overflow, `TRUE` otherwise.
             */
            change(o: string, n: string): boolean;
            /**
             * Destroy a buffer. Only needed for heap buffers. Leaves the buffer in the
             * _init state.
             */
            destroy(): void;
            /**
             * Trim to just the first line (excluding "\n").
             * @returns the `NULL`-terminated contents of the buffer. This is a pointer to the memory managed by the buffer and must not be freed.
             */
            firstline(): string;
            /**
             * Initialize a buffer.
             */
            init(): void;
            /**
             * Initialise and attach to a heap memory area.
             * The memory area needs to be at least 4 bytes long.
             *
             * ```c
             * VipsBuf buf;
             *
             * vips_buf_init_dynamic(&buf, 256);
             * ```
             *
             * Dynamic buffers must be freed with [method`Buf`.destroy], but their size can
             * be set at runtime.
             * @param mx the size of the storage area
             */
            init_dynamic(mx: number): void;
            /**
             * Initialise and attach to a static memory area. [func`BUF_STATIC]` is usually
             * more convenient.
             *
             * For example:
             *
             * ```c
             * char txt[256];
             * VipsBuf buf;
             *
             * vips_buf_init_static(&buf, txt, 256);
             * ```
             *
             * Static buffers don't need to be freed when they go out of scope, but their
             * size must be set at compile-time.
             * @param base the start of the memory area to use for storage
             * @param mx the size of the storage area
             */
            init_static(base: string, mx: number): void;
            is_empty(): boolean;
            is_full(): boolean;
            len(): number;
            /**
             * Remove the last character, if it's `ch`.
             * @param ch the character to remove
             * @returns `FALSE` on failure, `TRUE` otherwise.
             */
            removec(ch: number): boolean;
            /**
             * Reset the buffer to the empty string.
             */
            rewind(): void;
            /**
             * Attach the buffer to a heap memory area. The buffer needs to have been
             * initialised. The memory area needs to be at least 4 bytes long.
             * @param mx the size of the storage area
             */
            set_dynamic(mx: number): void;
            /**
             * Attach the buffer to a static memory area. The buffer needs to have been
             * initialised. The memory area needs to be at least 4 bytes long.
             * @param base the start of the memory area to use for storage
             * @param mx the size of the storage area
             */
            set_static(base: string, mx: number): void;
        }

        type ConnectionClass = typeof Connection;
        class Dbuf {
            static $gtype: GObject.GType<Dbuf>;

            // Constructors

            constructor(properties?: Partial<{}>);
            _init(...args: any[]): void;

            // Methods

            /**
             * Make sure `dbuf` has at least `size` bytes available after the write point.
             * @param size the size to allocate
             * @returns `FALSE` on out of memory, `TRUE` otherwise.
             */
            allocate(size: number): boolean;
            /**
             * Destroy `dbuf`. This frees any allocated memory. Useful for dbufs on the
             * stack.
             */
            destroy(): void;
            /**
             * Return a pointer to an area you can write to, return length of area in
             * `size`. Use [method`Dbuf`.allocate] before this call to set a minimum amount of
             * space to have available.
             *
             * The write point moves to just beyond the returned block. Use
             * [method`Dbuf`.seek] to move it back again.
             * @param size optionally return length in bytes here
             * @returns start of write area.
             */
            get_write(size?: number | null): number;
            /**
             * Initialize `dbuf`. You can also just init to zero, eg.
             * `VipsDbuf buf = {0};`.
             *
             * Destroy with [method`Dbuf`.destroy].
             */
            init(): void;
            /**
             * Make sure `dbuf` is at least `size` bytes.
             * @param size the minimum size
             * @returns `FALSE` on out of memory, `TRUE` otherwise.
             */
            minimum_size(size: number): boolean;
            /**
             * Up to `size` bytes are read from the buffer and copied to `data`. The number
             * of bytes transferred is returned.
             * @param data read to this area
             * @param size read up to this many bytes
             * @returns the number of bytes transferred.
             */
            read(data: number, size: number): number;
            /**
             * Reset the buffer to empty. No memory is freed, just the data size and
             * write point are reset.
             */
            reset(): void;
            /**
             * Move the write point. `whence` can be `SEEK_SET`, `SEEK_CUR`, `SEEK_END`, with
             * the usual meaning.
             * @param offset how to move the write point
             * @param whence from start, from end, from current
             */
            seek(offset: never, whence: number): boolean;
            /**
             * Destroy a buffer, but rather than freeing memory, a pointer is returned.
             * This must be freed with [func`GLib`.free].
             *
             * A `\0` is appended, but not included in the character count. This is so the
             * pointer can be safely treated as a C string.
             * @param size optionally return length in bytes here
             * @returns The pointer held by @dbuf.
             */
            steal(size?: number | null): number;
            /**
             * Return a pointer to `dbuf'`s internal data.
             *
             * A `\0` is appended, but not included in the character count. This is so the
             * pointer can be safely treated as a C string.
             * @param size optionally return length in bytes here
             * @returns The pointer held by @dbuf.
             */
            string(size?: number | null): number;
            tell(): never;
            /**
             * Truncate the data so that it ends at the write point. No memory is freed.
             */
            truncate(): void;
            /**
             * Append `size` bytes from `data`. `dbuf` expands if necessary.
             * @param data the data to write to the buffer
             * @param size the size of the len to write
             * @returns `FALSE` on out of memory, `TRUE` otherwise.
             */
            write(data: number, size: number): boolean;
            /**
             * Write `str` to `dbuf,` but escape stuff that xml hates in text. Our
             * argument string is utf-8.
             *
             * XML rules:
             *
             * - We must escape &<>
             * - Don't escape \n, \t, \r
             * - Do escape the other ASCII codes.
             * @param str string to write
             * @returns `FALSE` on out of memory, `TRUE` otherwise.
             */
            write_amp(str: string): boolean;
        }

        type ForeignClass = typeof Foreign;
        type ForeignLoadClass = typeof ForeignLoad;
        type ForeignSaveClass = typeof ForeignSave;
        class GInputStream {
            static $gtype: GObject.GType<GInputStream>;

            // Constructors

            _init(...args: any[]): void;
        }

        class GInputStreamClass {
            static $gtype: GObject.GType<GInputStreamClass>;

            // Constructors

            _init(...args: any[]): void;
        }

        type ImageClass = typeof Image;
        type InterpolateClass = typeof Interpolate;
        type ObjectClass = typeof Object;
        type OperationClass = typeof Operation;
        /**
         * A structure available to eval callbacks giving information on evaluation
         * progress. See [signal`Image:`:eval].
         */
        class Progress {
            static $gtype: GObject.GType<Progress>;

            // Fields

            run: number;
            eta: number;
            tpels: number;
            npels: number;
            percent: number;

            // Constructors

            _init(...args: any[]): void;

            // Static methods

            /**
             * If set, vips will print messages about the progress of computation to
             * stdout. This can also be enabled with the `--vips-progress` option, or by
             * setting the environment variable `VIPS_PROGRESS`.
             * @param progress `TRUE` to enable progress messages
             */
            static set(progress: boolean): void;
        }

        /**
         * A [struct`Rect]` is a rectangular area of pixels. This is a struct for
         * performing simple rectangle algebra.
         */
        class Rect {
            static $gtype: GObject.GType<Rect>;

            // Fields

            left: number;
            top: number;
            width: number;
            height: number;

            // Constructors

            constructor(
                properties?: Partial<{
                    left: number;
                    top: number;
                    width: number;
                    height: number;
                }>,
            );
            _init(...args: any[]): void;

            // Methods

            /**
             * Is `r1` equal to `r2`?
             * @param r2 second rectangle
             * @returns `TRUE` if @r1 is equal to @r2.
             */
            equalsrect(r2: Rect): boolean;
            /**
             * Does `r` contain point (`x,` `y)`?
             * @param x position to test for
             * @param y position to test for
             * @returns `TRUE` if @r contains (@x, @y).
             */
            includespoint(x: number, y: number): boolean;
            /**
             * Is `r2` a subset of `r1`?
             * @param r2 inner rectangle
             * @returns `TRUE` if @r2 is a subset of @r1.
             */
            includesrect(r2: Rect): boolean;
            /**
             * Fill `out` with the intersection of `r1` and `r2`. `out` can equal `r1` or `r2`.
             * @param r2 input rectangle 2
             */
            intersectrect(r2: Rect): Rect;
            /**
             * Is `r` empty? ie. zero width or height.
             * @returns `TRUE` if @r contains no pixels.
             */
            isempty(): boolean;
            /**
             * Enlarge `r` by `n`. +1 means out one pixel.
             * @param n enlarge by
             */
            marginadjust(n: number): void;
            /**
             * Make sure width and height are >0 by moving the origin and flipping the
             * rect.
             */
            normalise(): void;
            /**
             * Do `r1` and `r2` have a non-empty intersection?
             * @param r2 second rectangle
             * @returns `TRUE` if @r2 and @r1 overlap.
             */
            overlapsrect(r2: Rect): boolean;
            /**
             * Fill `out` with the bounding box of `r1` and `r2`. `out` can equal `r1` or `r2`.
             * @param r2 input rectangle 2
             */
            unionrect(r2: Rect): Rect;
        }

        class RefString {
            static $gtype: GObject.GType<RefString>;

            // Constructors

            constructor(str: string);
            _init(...args: any[]): void;

            static ['new'](str: string): RefString;

            // Methods

            /**
             * Get a pointer to the private string inside a refstr. Handy for language
             * bindings.
             *
             * ::: seealso
             *     [func`value_get_ref_string]`.
             * @returns The C string held by @refstr.
             */
            get(): [string, number];
        }

        type RegionClass = typeof Region;
        class SaveString {
            static $gtype: GObject.GType<SaveString>;

            // Fields

            s: string;

            // Constructors

            constructor(
                properties?: Partial<{
                    s: string;
                }>,
            );
            _init(...args: any[]): void;
        }

        type SbufClass = typeof Sbuf;
        class Semaphore {
            static $gtype: GObject.GType<Semaphore>;

            // Constructors

            _init(...args: any[]): void;

            // Methods

            destroy(): void;
            down(): number;
            down_timeout(timeout: number): number;
            downn(n: number): number;
            init(v: number, name: string): void;
            up(): number;
            upn(n: number): number;
        }

        type SourceClass = typeof Source;
        type SourceCustomClass = typeof SourceCustom;
        class SourceGInputStream {
            static $gtype: GObject.GType<SourceGInputStream>;

            // Constructors

            _init(...args: any[]): void;
        }

        class SourceGInputStreamClass {
            static $gtype: GObject.GType<SourceGInputStreamClass>;

            // Constructors

            _init(...args: any[]): void;
        }

        type TargetClass = typeof Target;
        type TargetCustomClass = typeof TargetCustom;
        type ThreadStateClass = typeof ThreadState;
        type ArgumentTable = GLib.HashTable;
        type Pel = number;
        /**
         * Name of the imported GIR library
         * `see` https://gitlab.gnome.org/GNOME/gjs/-/blob/master/gi/ns.cpp#L188
         */
        const __name__: string;
        /**
         * Version of the imported GIR library
         * `see` https://gitlab.gnome.org/GNOME/gjs/-/blob/master/gi/ns.cpp#L189
         */
        const __version__: string;
    }

    export default Vips;
}

declare module 'gi://Vips' {
    import Vips80 from 'gi://Vips?version=8.0';
    export default Vips80;
}
// END
