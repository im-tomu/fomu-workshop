/*	$OpenBSD: strlen.c,v 1.8 2014/06/10 04:17:37 deraadt Exp $	*/

/*-
 * Copyright (c) 1990, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <string.h>

size_t
strlen(const char *str)
{
	const char *s;

	for (s = str; *s; ++s)
		;
	return (s - str);
}

/**
 * memcpy - Copies one area of memory to another
 * @dest: Destination
 * @src: Source
 * @n: The size to copy.
 */
void *memcpy(void *to, const void *from, size_t n)
{
	void *xto = to;
	size_t temp;

	if(!n)
		return xto;
	if((long)to & 1) {
		char *cto = to;
		const char *cfrom = from;
		*cto++ = *cfrom++;
		to = cto;
		from = cfrom;
		n--;
	}
	if((long)from & 1) {
		char *cto = to;
		const char *cfrom = from;
		for (; n; n--)
			*cto++ = *cfrom++;
		return xto;
	}
	if(n > 2 && (long)to & 2) {
		short *sto = to;
		const short *sfrom = from;
		*sto++ = *sfrom++;
		to = sto;
		from = sfrom;
		n -= 2;
	}
	if((long)from & 2) {
		short *sto = to;
		const short *sfrom = from;
		temp = n >> 1;
		for (; temp; temp--)
			*sto++ = *sfrom++;
		to = sto;
		from = sfrom;
		if(n & 1) {
			char *cto = to;
			const char *cfrom = from;
			*cto = *cfrom;
		}
		return xto;
	}
	temp = n >> 2;
	if(temp) {
		long *lto = to;
		const long *lfrom = from;
		for(; temp; temp--)
			*lto++ = *lfrom++;
		to = lto;
		from = lfrom;
	}
	if(n & 2) {
		short *sto = to;
		const short *sfrom = from;
		*sto++ = *sfrom++;
		to = sto;
		from = sfrom;
	}
	if(n & 1) {
		char *cto = to;
		const char *cfrom = from;
		*cto = *cfrom;
	}
	return xto;
}