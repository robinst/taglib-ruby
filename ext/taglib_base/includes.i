%{
#if defined(HAVE_RUBY_ENCODING_H) && HAVE_RUBY_ENCODING_H
# include <ruby/encoding.h>
# define ASSOCIATE_UTF8_ENCODING(value) rb_enc_associate(value, rb_utf8_encoding());
#else
# define ASSOCIATE_UTF8_ENCODING(value) /* nothing */
#endif
%}
