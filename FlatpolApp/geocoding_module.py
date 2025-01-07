from geopy.geocoders import Nominatim
import time
from typing import Optional, Dict, Union
from dataclasses import dataclass


@dataclass
class GeoLocation:
    latitude: float
    longitude: float
    display_name: str


class GeocodingError(Exception):
    """Custom exception for geocoding errors"""
    pass


class AddressGeocoder:
    def __init__(self, user_agent: str = "geocoding_module"):
        """
        Initialize the geocoder with a custom user agent.

        Args:
            user_agent (str): Custom user agent for Nominatim service
        """
        self.geolocator = Nominatim(user_agent=user_agent)

    def format_address(self, country: str, city: str, street: str, number: str) -> str:
        """
        Format address components into a single string.

        Args:
            country (str): Country name
            city (str): City name
            street (str): Street name
            number (str): Street number

        Returns:
            str: Formatted address string
        """
        return f"{number} {street}, {city}, {country}"

    def get_coordinates(self,
                        country: str,
                        city: str,
                        street: str,
                        number: str) -> Optional[GeoLocation]:
        """
        Get coordinates for a given address.

        Args:
            country (str): Country name
            city (str): City name
            street (str): Street name
            number (str): Street number

        Returns:
            Optional[GeoLocation]: Location data if found, None otherwise

        Raises:
            GeocodingError: If there's an error during geocoding
        """
        address = self.format_address(country, city, street, number)

        try:
            # Add delay to respect Nominatim usage policy
            time.sleep(1)

            # Perform geocoding
            location = self.geolocator.geocode(address)

            if location:
                return GeoLocation(
                    latitude=location.latitude,
                    longitude=location.longitude,
                    display_name=location.address
                )
            return None

        except Exception as e:
            raise GeocodingError(f"Geocoding error: {str(e)}")


# Example usage
# from geocoding_module import AddressGeocoder, GeocodingError
#
# # Create an instance of the geocoder
# geocoder = AddressGeocoder(user_agent="your_application_name")
#
# try:
#     # Get coordinates
#     location = geocoder.get_coordinates(
#         country="France",
#         city="Paris",
#         street="Rue de Rivoli",
#         number="1"
#     )
#
#     if location:
#         print(f"Latitude: {location.latitude}")
#         print(f"Longitude: {location.longitude}")
#         print(f"Full address: {location.display_name}")
#     else:
#         print("Location not found")
#
# except GeocodingError as e:
#     print(f"Error: {e}")