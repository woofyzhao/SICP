;The serialized exchange process can't proceed since it calls the withdraw procedure that is serialized
;with the same serializer with exchange itself.
;Thus it will wait for itself to finish (deadlock).