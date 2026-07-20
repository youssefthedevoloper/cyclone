from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path(
        "api/docs/",
        SpectacularSwaggerView.as_view(url_name="schema"),
        name="swagger-ui",
    ),
    path("api/auth/", include("apps.users.urls")),

    # Domain APIs
    path("api/", include("apps.airports.urls")),
    path("api/", include("apps.flights.urls")),
    path("api/", include("apps.trips.urls")),
    path("api/", include("apps.tickets.urls")),
    path("api/", include("apps.notifications.urls")),
    path("api/", include("apps.lost_found.urls")),
    path("api/", include("apps.settings.urls")),
]

